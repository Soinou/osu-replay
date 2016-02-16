body_parser = require "body-parser"
express = require "express"
exceptions = require "express-exceptions"
express_validator = require "express-validator"
morgan = require "morgan"
util = require "util"
process = require "process"

# Defines an express application wrapper
exports = module.exports = class Application

    # Creates a new Application
    constructor: (@logger_, @router_) ->
        @app_ =  express()

    # Setups the application middlewares
    setup: () ->
        @logger_.debug "Setting up application middleware"

        # Set some parameters
        @app_.set "view engine", "jade"

        # Setup some middleware
        @app_.use express.static "public"
        @app_.use morgan "tiny"
        @app_.use body_parser.urlencoded extended: false
        @app_.use body_parser.json()
        @app_.use express_validator()

        @logger_.debug "Application middleware setup, installing routes"

        # Aadd routes
        @router_.install @app_

        @logger_.debug "Routes installed"

        # Exception middleware
        @app_.use exceptions(defaultErrorPage: "errors/500")

        @logger_.debug "Application initialized"

    # Starts the application
    start: () ->
        port = process.env.PORT || 5000

        @app_.listen port, (err) =>
            if err
                @logger_.fatal "Could not start application: " + err
            else
                @logger_.success "Application listening on port " + port

    # Error middleware
    _error: (err, req, res, next) =>
        @logger_.error err.stack
        res.status(500).render "/errors/500", error: err

exports["@singleton"] = true
exports["@require"] = [ "logger", "router" ]
