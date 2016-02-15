extend = require("util")._extend
fs = require "fs-extra"
{make_esc} = require "iced-error"
mods = require "./mods"

# Replay data wrapper, adding a few useful methods
class Replay

    # Creates a new Replay
    constructor: (data) ->
        extend this, data

    get_game_mode: ->
        switch @mode
            when 0 then "Standard"
            when 1 then "Taiko"
            when 2 then "Catch The Beat"
            when 3 then "Mania"

    get_game_mode_icon: ->
        switch @mode
            when 0 then "fa osu fa-osu-o"
            when 1 then "fa osu fa-taiko-o"
            when 2 then "fa osu fa-fruits-o"
            when 3 then "fa osu fa-mania-o"

    # Returns the list of mods present in this replay
    get_mods: ->
        return mods.get_mods @mods

    get_beatmap_link: ->
        return "https://osu.ppy.sh/b/" + @beatmap.beatmap_id

    get_beatmap_set_link: ->
        return "https://osu.ppy.sh/s/" + @beatmap.beatmapset_id

    get_player_link: ->
        return "https://osu.ppy.sh/u/" + @player.user_id

# Factory to create replays
exports = module.exports = class ReplayFactory

    # Creates a new factory
    constructor: (@beatmaps_, @buffer_reader_, @logger_, @storage_, @users_) ->

    # Creates a new Replay based on data taken from the database
    from_data: (data, callback) ->
        esc = make_esc callback
        @logger_.debug "Populating replay from store data, getting beatmap"
        await @beatmaps_.get data.beatmap, esc(defer(beatmap))
        if not beatmap? then return callback new Error "Beatmap does not exist, please check the replay file"
        @logger_.debug "Got the beatmap, getting the player"
        await @users_.get data.player, esc(defer(user))
        if not user? then return callback new Error "Player does not exist, please check the replay file"
        @logger_.debug "Got the player, returning the completed replay"
        data.beatmap = beatmap
        data.player = user
        data.link = @storage_.link data._id
        callback null, new Replay data

    # Creates a new Replay based on a file buffer
    from_file: (path, callback) ->
        esc = make_esc callback
        @logger_.debug "Reading file \"" + path + "\""
        await fs.readFile path, esc(defer(data))
        @logger_.debug "File \"" + path + "\" successfully read, parsing replay"
        reader = @buffer_reader_.create data
        replay = {}
        replay.mode = reader.read_byte()
        replay.version = reader.read_int()
        replay.beatmap = reader.read_string()
        replay.player = reader.read_string()
        replay.hash = reader.read_string()
        replay.n_300 = reader.read_short()
        replay.n_100 = reader.read_short()
        replay.n_50 = reader.read_short()
        replay.gekis = reader.read_short()
        replay.katus = reader.read_short()
        replay.misses = reader.read_short()
        replay.score = reader.read_int()
        replay.combo = reader.read_short()
        replay.perfect = reader.read_byte()
        replay.mods = reader.read_int()
        reader.read_string() # Replay life bar graph, useless
        replay.timestamp = reader.read_long()
        @logger_.debug "Replay successfully parsed"
        callback null, replay

exports["@singleton"] = true
exports["@require"] = [
    "beatmap_store",
    "buffer_reader",
    "logger",
    "storage",
    "user_store"
]
