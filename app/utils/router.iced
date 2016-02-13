# Represents a router, setting up routes of the application
exports = module.exports = class Router

    # Creates a new router
    constructor: (@replays_) ->

    # Installs the router to the given express application
    install: (app) ->
        @replays_.install(app)

exports["@singleton"] = true
exports["@require"] = [ "replays_controller" ]
