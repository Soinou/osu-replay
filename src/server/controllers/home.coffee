# Represents the home controller
module.exports = class HomeController

    install: (app) ->
        # Ping page for pingdom
        app.get "/ping", (req, res) ->
            res.send "PONG"

        # I'm a teapot
        app.get "/teapot", (req, res) ->
            res.status(418).send "I'm a teapot"

        # Home page
        app.get "*", (req, res) ->
            res.render "app"
