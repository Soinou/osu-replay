module.exports = class Application

    dependencies: -> [
        "body_parser",
        "exceptions",
        "express",
        "express_validator",
        "HomeController",
        "http",
        "irc",
        "logger",
        "memwatch",
        "morgan",
        "Promise",
        "ReplaysController",
        "session",
        "socket_io",
        "UsersController"
    ]

    initialized: ->
        @app_ = @express()
        @app_.http().io()
        @memwatch.on "leak", @onLeak
        @memwatch.on "stats", @onStats

    setup: ->
        @logger.debug "Setting up application middleware"

        # Set some parameters
        @app_.set "view engine", "jade"
        @app_.set "views", "src/views"

        # Setup some middleware
        @app_.use @express.static "public"
        @app_.use @session {
            secret: "keyboard cat"
            resave: false,
            saveUninitialized: false
        }
        @app_.use @morgan "tiny"
        @app_.use @body_parser.urlencoded extended: false
        @app_.use @body_parser.json()
        @app_.use @express_validator()

        @logger.debug "Express app middleware setup, installing routes"

        # Add routes
        @HomeController.install @app_
        @ReplaysController.install @app_
        @UsersController.install @app_

        @logger.debug "Routes installed"

        # Exception middleware
        @app_.use @exceptions(defaultErrorPage: "errors/500")

        @logger.debug "Application initialized"

    start: ->
        port = process.env.PORT || 5000

        listen = new Promise (resolve, reject) =>
            @app_.listen port, (err) ->
                if err then reject err
                else resolve()

        listen.then () =>
            @logger.debug "Application listening on port " + port
            # @irc.connect()
        .then () => @logger.debug "Irc client started"
        .catch (err) => @logger.fatal "Application couldn't start: ", err

    # Stops the application
    stop: -> @server_.close()

    onLeak: (info) =>
        @logger.warning "Memory leak: " + info.toString()

    onStats: (stats) =>
        @logger.debug "Heap stats: " + stats.toString()

    # Error middleware
    _error: (err, req, res, next) =>
        @logger.error err.stack
        res.status(500).render "/errors/500", error: err
