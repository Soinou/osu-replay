# Defines a store of osu! replays
module.exports = class ReplayStore

    dependencies: -> [
        "logger",
        "moment",
        "Promise",
        "replay",
        "storage",
        "store"
    ]

    # Creates a new ReplayStore
    initialized: ->
        @store_ = @store.create "replays"

    all: -> @store_.all

    find: (key) -> @store_.find key

    get: (key) -> @store_.find(key).then (doc) =>
        if not doc? then return @Promise.resolve null
        else return @replay.from_data doc

    save: (key, params) ->
        @logger.debug "Loading replay data from file"
        return @replay.from_file params.path
        # Get the replay at first
        .then (replay) =>
            @logger.debug "Inserting replay to the replays store"
            replay.title = params.title or "No title"
            replay.description = params.description or "No description"
            replay.created_at = @moment().format()
            replay.updated_at = @moment().format()
            return @store_.insert key, replay
        .then () =>
            @logger.debug "Replay inserted to the replays store"
            return @storage.upload params.path, key

    update: (key, params) -> @store_.update key, params
