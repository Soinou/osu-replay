numeral = require "numeral"
util = require "util"

Mods = require "osu/mods.coffee"

# Replay data wrapper, adding a few useful methods
module.exports = class Replay

    # Creates a new Replay
    constructor: (data) ->
        util._extend this, data

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

    get_score: ->
        return numeral(@score).format "0,0"

    get_combo: ->
        return numeral(@combo).format "0,0"

    get_standard_accuracy: ->
        points = @n_50 * 50 + @n_100 * 100 + @n_300 * 300
        hits = (@misses + @n_50 + @n_100 + @n_300) * 300
        return (points / hits * 100).toFixed 2

    get_taiko_accuracy: ->
        points = (@n_100 * 0.5 + @n_300) * 300
        hits = (@misses + @n_100 + @n_300) * 300
        return (points / hits * 100).toFixed 2

    get_fruits_accuracy: ->
        caught = @n_50 + @n_100 + @n_300
        total = @misses + caught
        return (caught / total * 100).toFixed 2

    get_mania_accuracy: ->
        points = @n_50 * 50 + @n_100 * 200 + @katus * 100 + @n_300 * 300 + @gekis * 300
        hits = (@misses + @n_50 + @n_100 + @katus + @n_300 + @gekis) * 300
        return (points / hits * 100).toFixed 2

    get_accuracy: ->
        switch @mode
            when 0 then return @get_standard_accuracy()
            when 1 then return @get_taiko_accuracy()
            when 2 then return @get_fruits_accuracy()
            when 3 then return @get_mania_accuracy()

    # Returns the list of mods present in this replay
    get_mods: ->
        return Mods.get_mods @mods

    get_avatar_link: ->
        return "https://a.ppy.sh/" + @player.user_id

    get_beatmap_link: ->
        return "https://osu.ppy.sh/b/" + @beatmap.beatmap_id

    get_beatmap_set_link: ->
        return "https://osu.ppy.sh/s/" + @beatmap.beatmapset_id

    get_player_link: ->
        return "https://osu.ppy.sh/u/" + @player.user_id
