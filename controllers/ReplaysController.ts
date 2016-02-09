import * as fs from "fs";
import * as multer from "multer";
import * as path from "path";
import Logger from "../components/Logger";
import Storage from "../components/Storage";
import * as mongoose from "mongoose";

type Model = mongoose.Model<mongoose.Document>;

// Replays controller
export default class ReplaysController
{
    // Multer upload helper
    protected _upload: any;
    protected _logger: Logger;
    protected _replay: Model;
    protected _storage: Storage;

    // Creates a new ReplaysController
    constructor(logger, replay, storage)
    {
        this._logger = logger;
        this._replay = replay;
        this._storage = storage;
        this._upload = multer({ dest: "public/uploads/" });
    }

    // Creates a new replay
    create = (req, res) =>
    {
        var replay_id = req.file.filename
        var replay_title = req.body.title
        var replay_description = req.body.description
        var replay_path = req.file.path + ".osr"

        // Called once the unlink is done
        var on_unlink = (err) =>
        {
            if(err)
            {
                this._logger.error("Could not delete replay file: " + err);
                res.render("errors/500");
            }
            else
            {
                res.redirect("/replay/" + replay_id);
            }
        };

        // Called once the replay is saved
        var on_replay_saved = (err) =>
        {
            if(err)
            {
                this._logger.error("Could not save a replay to the database: " + err);
                return res.render("errors/500");
            }
            else
            {
                fs.unlink(replay_path, on_unlink);
            }
        }

        // Called once the upload is done
        var on_upload = (err) =>
        {
            if(err)
            {
                res.render("errors/500");
            }
            else
            {
                var replay = new this._replay(
                {
                    id: replay_id,
                    title: replay_title,
                    description: replay_description
                });

                replay.save(on_replay_saved);
            }
        };

        // Called once the rename is done
        var on_rename = (err) =>
        {
            if(err)
            {
                this._logger.error("Could not rename file from \"" + req.file.path + "\" to \"" + replay_path + "\": " + err);
                res.render("errors/500");
            }
            else
            {
                this._storage.upload(replay_path, replay_id + ".osr", on_upload);
            }
        };

        fs.rename(req.file.path, replay_path, on_rename);
    }

    // Shows a replay
    show = (req, res) =>
    {
        this._replay.findOne({ id: req.params.id }, (err, replay) =>
        {
            if(err)
            {
                this._logger.error("Could not retrieve replay with id \"" + req.params.id + "\" from the database: " + err);
                res.render("errors/500");
            }
            else if(!replay)
            {
                this._logger.warning("Replay with id \"" + req.params.id + "\" does not exist in the database");
                res.render("errors/404");
            }
            else
            {
                res.render("replay", {replay: replay});
            }
        });
    }

    // Installs the controller to the given express application
    install(application)
    {
        this._logger.info("Installing ReplaysController...");

        application.post("/replay", this._upload.single("file"), this.create);

        application.get("/replay/:id", this.show);

        this._logger.info("ReplaysController successfully installed");
    }
}

// Electrolyte exports
exports = module.exports = ReplaysController;
exports["@singleton"] = true;
exports["@require"] = [ "Logger", "Replay", "Storage" ]
