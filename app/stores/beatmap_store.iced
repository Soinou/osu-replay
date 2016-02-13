{make_esc} = require "iced-error"

exports = module.exports = class UserStore

    constructor: (@api_, store) ->
        @store_ = store.create "beatmaps"

    get: (key, callback) ->
        esc = make_esc callback
        await @store_.find key, esc(defer(beatmap))
        if not beatmap?
            await @api_.get_beatmaps h: key, esc(defer(beatmaps))
            if beatmaps.length > 0
                beatmap = beatmaps[0]
            await @store_.insert key, beatmap, esc(defer())
        callback null, beatmap

exports["@singleton"] = true
exports["@require"] = [ "api", "store" ]
