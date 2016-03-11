module.exports = class Application

    dependencies: -> [
        "ErrorMiddleware",
        "express",
        "GeneralMiddleware",
        "irc",
        "logger",
        "LogMiddleware",
        "MainController",
        "memwatch",
        "Promise",
        "ReplaysController",
        "SessionMiddleware",
        "UsersController"
    ]

    initialized: ->
        @app_ = @express()
        @app_.http().io()
        @memwatch.on "leak", @onLeak
        @memwatch.on "stats", @onStats

    setup: ->
        # Middleware
        @LogMiddleware.install @app_
        @GeneralMiddleware.install @app_
        @SessionMiddleware.install @app_

        # Controllers
        @ReplaysController.install @app_
        @UsersController.install @app_
        @MainController.install @app_

        # Error handling
        @ErrorMiddleware.install @app_

    start: ->
        bind = process.env.BIND or 5000

        listen = new Promise (resolve, reject) =>
            @app_.listen bind, (err) -> if err then reject err else resolve()

        listen.then (server) =>
            @logger.debug "Application listening on " + bind
            # @irc.connect()
        .catch (err) => @logger.fatal "Application couldn't start: ", err

    # Stops the application
    stop: -> @server_.close()

    onLeak: (info) =>
        @logger.warning "Memory leak: " + info.toString()

    onStats: (stats) =>
        @logger.debug "Heap stats: " + stats.toString()
