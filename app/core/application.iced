body_parser = require "body-parser"
express = require "express"
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
        @app_.set "view engine", "jade"
        @app_.use express.static "public"
        @app_.use morgan "dev"
        @app_.use body_parser.urlencoded extended: false
        @app_.use body_parser.json()
        @logger_.debug "Application middleware setup, installing routes"
        @app_.get "/", (req, res) =>
            res.render "home"
        @logger_.debug "Routes installed"
        @router_.install @app_
        @app_.use @_error
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
        console.dir res
        @logger_.error err.stack
        res.status(500).render "/errors/500", error: err

exports["@singleton"] = true
exports["@require"] = [ "logger", "router" ]
