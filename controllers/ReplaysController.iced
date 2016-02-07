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

        fs.rename req.file.path, req.file.path + ".osr", (err) ->
            if err
                app.error "Could not rename file from \"" + req.file.path + "\" to \"" + req.file.path + ".osr\": " + err
                res.render "errors/500"

            replay = new Replay
                id: replay_id,
                title: replay_title,
                description: replay_description

            replay.save (err) ->
                if err
                    app.error "Could not save a replay to the database: " + err
                    res.render "errors/500"

                res.redirect "/replay/" + replay_id

    app.get "/replay/:id", (req, res) ->
        Replay.findOne { id: req.params.id }, (err, replay) ->
            if err
                app.error "Could not retrieve replay with id \"" + req.params.id + "\" from the database: " + err
                res.render "errors/500"
            else if not replay?
                app.warning "Replay with id \"" + req.params.id + "\" does not exist in the database"
                res.render "errors/404"
            else
                res.render "replay", {replay: replay}
