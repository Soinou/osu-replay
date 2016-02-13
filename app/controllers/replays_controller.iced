multer = require "multer"
upload = multer dest: "public/uploads/"
uuid = require "node-uuid"

# Represents a replays controller
exports = module.exports = class ReplaysController

    # Creates a new ReplaysController
    constructor: (@logger_, @replays_) ->

    # Installs the controller to the given express app
    install: (app) ->
        app.post "/replay", upload.single("file"), @_create
        app.get "/replay/:id", @_show
        @logger_.debug "ReplaysController installed"

    # POST /replay
    _create: (req, res) =>
        key = req.file.filename
        # Could be a good idea to test some inputs
        params =
            title: req.body.title,
            description: req.body.description,
            path: req.file.path
        @logger_.debug "Saving a new replay"
        await @replays_.save key, params, defer err
        if err
            @logger_.error "Impossible to save a replay: " + err
            res.render "errors/500"
        else
            @logger_.debug "Replay \"" + key + "\" successfully saved"
            res.redirect "/replay/" + key

    # GET /replay/:id
    _show: (req, res) =>
        key = req.params.id
        @logger_.debug "Searching for replay \"" + key + "\""
        await @replays_.get key, defer err, replay
        if err
            @logger_.error "Impossible to get replay \"" + key + "\": " + err
            res.render "errors/500"
        else if not replay?
            @logger_.warning "Replay \"" + key + "\" does not exist"
            res.render "errors/404"
        else
            @logger_.debug "Replay \"" + key + "\" successfully found"
            res.render "replay", replay: replay

exports["@singleton"] = true
exports["@require"] = [ "logger", "replay_store" ]
