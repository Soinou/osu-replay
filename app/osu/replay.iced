fs = require "fs-extra"
{make_esc} = require "iced-error"

# Factory to create replays
exports = module.exports = class ReplayFactory

    # Creates a new factory
    constructor: (@beatmaps_, @buffer_reader_, @logger_, @storage_, @users_) ->

    # Creates a new Replay based on data taken from the database
    from_data: (data, callback) ->
        esc = make_esc callback
        @logger_.debug "Populating replay from store data, getting beatmap"
        await @beatmaps_.get data.beatmap, esc(defer(beatmap))
        @logger_.debug "Got the beatmap, getting the player"
        await @users_.get data.player, esc(defer(user))
        @logger_.debug "Got the player, returning the completed replay"
        data.beatmap = beatmap
        data.player = user
        data.link = @storage_.link data._id
        callback null, data

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
