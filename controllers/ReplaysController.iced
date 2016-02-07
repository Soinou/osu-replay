fs = require "fs"
multer = require "multer"
path = require "path"

module.exports = (app) ->
    upload = multer { dest: "public/uploads/" }
    Replay = app.getModel("Replay")

    app.post "/replay", upload.single("file"), (req, res) ->
        replay_id = req.file.filename
        replay_title = req.body.title
        replay_description = req.body.description
        replay_path = req.file.path + ".osr"

        await fs.rename req.file.path, replay_path, defer err

        if err
            app.error "Could not rename file from \"" + req.file.path + "\" to \"" + replay_path + "\": " + err
            return res.render "errors/500"

        await app.upload replay_path, replay_id + ".osr", defer err

        if err then return res.render "errors/500"

        replay = new Replay
            id: replay_id,
            title: replay_title,
            description: replay_description

        await replay.save defer err

        if err
            app.error "Could not save a replay to the database: " + err
            return res.render "errors/500"

        await fs.unlink replay_path, defer err

        if err
            app.error "Could not delete replay file: " + err
            return res.render "errors/500"

        res.redirect "/replay/" + replay_id

    app.get "/replay/:id", (req, res) ->
        await Replay.findOne { id: req.params.id }, defer err, replay

        if err
            app.error "Could not retrieve replay with id \"" + req.params.id + "\" from the database: " + err
            res.render "errors/500"
        else if not replay?
            app.warning "Replay with id \"" + req.params.id + "\" does not exist in the database"
            res.render "errors/404"
        else
            res.render "replay", {replay: replay}
