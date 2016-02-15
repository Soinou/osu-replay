
# Represents the home controller
exports = module.exports = class HomeController

    constructor: ->

    install: (app) ->
        # Home page
        app.get "/", (req, res) ->
            res.render "home"

        # Ping page for pingdom
        app.get "/ping", (req, res) ->
            res.send "PONG"

        # I'm a teapot
        app.get "/teapot", (req, res) ->
            res.status(418).send "I'm a teapot"
