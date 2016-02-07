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
        @_models = new Dict
        @_app = express()

    # Returns the given model
    getModel: (name) ->
        @_models.get name

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
            @_models.set path.basename(file, ".iced"), require directory + file

    # Loads controllers
    loadControllers: ->
        directory = @_root + "/controllers/"

        for file in fs.readdirSync directory
           require(directory + file)(this)

    # Loads everything needed by the application
    load: ->
        dotenv.config()

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

        console.log "Connecting to the db at the url: " + url

        mongoose.connect url, (err) =>
            if err
                console.log err
                throw err

            @_app.listen process.env.PORT || 5000, () ->
                console.log "osu-replay started"

    # Express app.get
    get: (args...) ->
        @_app.get args...

    # Express app.post
    post: (args...) ->
        @_app.post args...
