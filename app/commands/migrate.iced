{make_esc} = require "iced-error"
fs = require "fs-extra"
path = require "path"

# Disable all debug logs
process.env.LOG_LEVEL=1

exports = module.exports = class MigrateCommand

    constructor: (@logger_, @beatmaps_, @replays_, @store_, @users_) ->
        @logger_.info "Starting the migrations"
        # Link to the migrations store on mongodb
        @migrations_store_ = @store_.create "migrations"

    _run: (migration, callback) =>
        esc = make_esc callback
        # Get the migration name
        name = path.basename migration, ".iced"
        await @migrations_store_.find name, esc(defer(results))
        if results?
            @logger_.info "Migration already run"
            return callback null
        @logger_.info "Will run migration " + name
        try
            migration_class = require "../../migrations/" + name
            migration_object = new migration_class
            await migration_object.run @logger_, @beatmaps_, @replays_, @users_, esc(defer())
            await @migrations_store_.insert name, run: true, esc(defer())
            @logger_.info "Migration " + name + " run"
            return callback null
        catch error
            return callback error

    run: ->
        @logger_.info "Scanning migrations"
        filter = (file) -> return file.substr(-5) is ".iced"
        migrations = fs.readdirSync("migrations").filter(filter)
        for migration in migrations
            await @_run migration, defer err
            if err then return @logger_.fatal err
        process.exit 0

exports["@require"] = [
    "logger",
    "beatmap_store",
    "replay_store",
    "store",
    "user_store"
]
