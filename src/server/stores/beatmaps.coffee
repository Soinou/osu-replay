module.exports = class BeatmapStore

    dependencies: -> ["api", "store", "Promise"]

    initialized: ->
        @store_ = @store.create "beatmaps"

    get: (key, mode, callback) ->
        return @store_.find key
        .then (doc) =>
            if doc? then return @Promise.resolve doc
            else
                return @api.get_beatmap {h: key, m: mode}
                .then (beatmap) =>
                    return @store_.insert key, beatmap
