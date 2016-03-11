module.exports = class GeneralMiddleware
    dependencies: -> ["body_parser", "express"]

    install: (app) ->
        app.use @express.static "public"
        app.use @body_parser.urlencoded extended: false
        app.use @body_parser.json()
