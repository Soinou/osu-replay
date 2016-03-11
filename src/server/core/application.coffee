module.exports = class Application

    dependencies: -> [
        "ErrorMiddleware",
        "express",
        "GeneralMiddleware",
        "http",
        "irc",
        "logger",
        "LogMiddleware",
        "MainController",
        "Promise",
        "ReplaysController",
        "SessionMiddleware",
        "UsersController"
    ]

    initialized: ->
        @app_ = @express()
        @app_.http().io()

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
        if process.env.PORT? then bind = process.env.PORT
        else if process.env.SOCKET? then bind = process.env.SOCKET
        else bind = 5000

        listen = new Promise (resolve, reject) =>
            @app_.listen bind, (err) -> if err then reject err else resolve()

        listen.then (server) =>
            @logger.debug "Application listening on " + bind
            # @irc.connect()
        .catch (err) => @logger.fatal "Application couldn't start: ", err

    # Stops the application
    stop: -> @app_.server.close()
