module.exports = class PlayerStore

    dependencies: -> ["api", "Promise", "store"]

    initialized: -> @store_ = @store.create "players"

    get: (key, mode) ->
        return @store_.find key
        .then (doc) =>
            if doc? then return @Promise.resolve doc
            else
                return @api.get_user {u: key, m: mode}
                .then (player) =>
                    doc = player
                    return @store_.insert key, doc
                .then => return @Promise.resolve doc
