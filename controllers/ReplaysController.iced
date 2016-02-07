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
            if err then res.render "errors/500"

            replay = new Replay
                id: replay_id,
                title: replay_title,
                description: replay_description

            replay.save (err) ->
                if err then res.render "errors/500"

                res.redirect "/replay/" + replay_id

    app.get "/replay/:id", (req, res) ->
        Replay.findOne { id: req.params.id }, (err, replay) ->
            if err
                res.render "errors/500"
            else if not replay?
                res.render "errors/404"
            else
                res.render "replay", {replay: replay}
