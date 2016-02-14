path = require "path"

# Represents a replays controller
exports = module.exports = class ReplaysController

    # Creates a new ReplaysController
    constructor: (@logger_, @replays_, @uploader_) ->

    # Installs the controller to the given express app
    install: (app) ->
        app.post "/replay", @uploader_.single("file"), @_create
        app.get "/replay/:id", @_show
        @logger_.debug "ReplaysController installed"

    # POST /replay
    _create: (req, res) =>
        # Some validation rules
        req.check("title", "Title must not be empty").notEmpty()
        req.check("title", "Title must be 3-30 characters long").isLength({min: 3, max:30})
        req.check("description", "description must not be empty").notEmpty()
        req.check("description", "description must be 3-255 characters long").isLength({ min: 3, max: 255})

        # Validate inputs
        errors = req.validationErrors(true)

        # Also validate the file field
        if not req.file? then errors.file = {param: "file", msg: "File given is not valid", value: ""}

        # If we have errors send them back
        if errors then return res.render "home", errors: errors

        # Replay key is the file name without the extension
        key = req.file.id

        # Replay parameters (Get data from the request)
        params =
            title: req.body.title,
            description: req.body.description,
            path: req.file.path,
            name: req.file.filename

        # Save the replay
        @logger_.debug "Saving a new replay"
        await @replays_.save key, params, defer err

        # Display error page if there is an error
        if err
            @logger_.error "Impossible to save a replay: " + err
            res.status(500).render "errors/500", error: err
        else
            @logger_.debug "Replay \"" + key + "\" successfully saved"
            res.redirect "/replay/" + key

    # GET /replay/:id
    _show: (req, res, next) =>

        return next(new Error("I HAZ SOME ERROR"))

        # Get the replay id
        key = req.params.id

        # Search for it
        @logger_.debug "Searching for replay \"" + key + "\""
        await @replays_.get key, defer err, replay

        # Display errors/500 if we have an error
        if err
            @logger_.error "Impossible to get replay \"" + key + "\": " + err
            res.status(500).render "errors/500", error: err
        # Display errors/404 if the replay is not found
        else if not replay?
            @logger_.warning "Replay \"" + key + "\" does not exist"
            res.status(404).render "errors/404"
        # Display the replay if we have it
        else
            @logger_.debug "Replay \"" + key + "\" successfully found"
            res.render "replay", replay: replay

exports["@singleton"] = true
exports["@require"] = [ "logger", "replay_store", "uploader"]
