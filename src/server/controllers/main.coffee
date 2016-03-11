# Represents the main controller
module.exports = class MainController

    dependencies: -> ["logger"]

    install: (app) ->
        # Ping page for StatusCake
        app.get "/ping", (req, res) -> res.send "PONG"

        # I'm a teapot
        app.get "/teapot", (req, res) -> res.status(418).send "I'm a teapot"

        # Used only for the tests
        app.get "*", (req, res) -> res.sendfile "public/index.html"
