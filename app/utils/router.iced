# Represents a router, setting up routes of the application
exports = module.exports = class Router

    # Creates a new router
    constructor: (@home_, @replays_) ->

    # Installs the router to the given express application
    install: (app) ->
        @home_.install app
        @replays_.install app

exports["@singleton"] = true
exports["@require"] = [ "home_controller", "replays_controller" ]
