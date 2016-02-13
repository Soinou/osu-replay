{make_esc} = require "iced-error"

# Defines a store of osu! replays
exports = module.exports = class ReplayStore

    # Creates a new ReplayStore
    constructor: (@logger_, @replay_, @storage_, store) ->
        @store_ = store.create "replays"

    # Gets a replay by its key
    get: (key, callback) ->
        esc = make_esc callback
        @logger_.debug "Searching for replay with key \"" + key + "\""
        await @store_.find key, esc(defer(replay))
        if replay?
            @logger_.debug "Found a replay in the store, populating it..."
            await @replay_.from_data replay, esc(defer(replay))
            @logger_.debug "Replay populated"
        callback null, replay

    # Saves a replay using its key and some parameters
    # Params should contains replay, description and file path
    save: (key, params, callback) ->
        esc = make_esc callback
        @logger_.debug "Loading replay data from file"
        await @replay_.from_file params.path, esc(defer(replay))
        @logger_.debug "Replay data loaded, uploading replay file"
        await @storage_.upload params.path, key, esc(defer())
        @logger_.debug "Replay file uploaded, saving data to the store"
        replay.title = params.title or "No title"
        replay.description = params.description or "No description"
        await @store_.insert key, replay, esc(defer())
        @logger_.debug "Replay saved"
        callback null

# Exports
exports["@singleton"] = true
exports["@require"] = [ "logger", "replay", "storage", "store" ]