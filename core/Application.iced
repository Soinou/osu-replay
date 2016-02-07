bodyParser = require "body-parser"
Dict = require "collections/dict"
dotenv = require "dotenv"
express = require "express"
fs = require "fs"
mongoose = require "mongoose"
morgan = require "morgan"
path = require "path"
util = require "util"

# Application class
module.exports = class Application

    # Constructor
    constructor: (@_root) ->
        @_helpers = new Dict
        @_models = new Dict
        @_app = express()

    # Returns the given model
    getModel: (name) ->
        @_models.get name

    # Loads helpers
    loadHelpers: ->
        directory = @_root + "/helpers/"

        for file in fs.readdirSync directory
            helper = require directory + file
            @_helpers.set path.basename(file, ".iced"), new helper this

        @info "All helpers loaded"

    # Loads express application
    loadApp: ->
        @_app.set "view engine", "jade"
        @_app.use express.static @_root + "/public"
        @_app.use morgan "dev"
        @_app.use bodyParser.urlencoded { extended: false }
        @_app.use bodyParser.json()

        @_app.get "/", (req, res) ->
            res.render "home"

    # Loads Models
    loadModels: ->
        directory = @_root + "/models/"

        for file in fs.readdirSync directory
            name = path.basename(file, ".iced")
            model = require directory + file
            @_models.set name, model this
            @info "Model \"" + name + "\" loaded"

    # Loads controllers
    loadControllers: ->
        directory = @_root + "/controllers/"

        for file in fs.readdirSync directory
            name = path.basename(file, ".iced")
            require(directory + file)(this)
            @info "Controller \"" + name + "\" loaded"

    # Loads everything needed by the application
    load: ->
        dotenv.config()

        @loadHelpers()
        @loadApp()
        @loadModels()
        @loadControllers()

    # Starts the application
    start: ->
        url = util.format "mongodb://%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH

        mongoose.connect url, (err) =>
            if err
                @fatal err

            port = process.env.PORT || 5000

            @_app.listen port, () =>
                @info "Application started on port " + port

    # Express app.use
    use: (args...) =>
        @_app.use args...

    # Express app.get
    get: (args...) ->
        @_app.get args...

    # Express app.post
    post: (args...) ->
        @_app.post args...
