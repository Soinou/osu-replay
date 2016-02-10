import { Application, Request, Response } from "express";
import * as fs from "fs";
import * as multer from "multer";
import * as path from "path";

import ILogger from "../services/Logger";
import IStorage from "../services/Storage";
import IReplayRepository from "../repositories/ReplayRepository";
import IController from "./IController";

import { Inject } from "inversify";

/**
 * Replays Controller interface
 */
interface IReplaysController extends IController
{ }

/**
 * Implementation of the IReplaysController
 */
@Inject("ILogger", "IReplayRepository", "IStorage")
export class ReplaysController implements IReplaysController {
    /**
     * Multer upload middleware
     */
    protected upload_: any;

    /**
     * Creates a new ReplaysController
     *
     * @param logger_ Logger service
     * @param replays_ Replays repository
     * @param storage_ Storage service
     */
    constructor(protected logger_: ILogger, protected replays_: IReplayRepository, protected storage_: IStorage) {
        this.upload_ = multer({ dest: "public/uploads/" });
    }

    /**
     * Creates a new replay
     *
     * @param req Express request object
     * @param res Express response object
     */
    create = (req: any, res: Response) => {
        var replay_id = req.file.filename;
        var replay_title = req.body.title;
        var replay_description = req.body.description;
        var replay_path = req.file.path + ".osr";
        var replay_link = this.storage_.link(replay_id) + ".osr";

        // Called once the unlink is done
        var on_unlink = (err) => {
            if (err) {
                this.logger_.error("Could not delete replay file: " + err);
                res.render("errors/500");
            }
            else {
                res.redirect("/replay/" + replay_id);
            }
        };

        // Called once the replay is saved
        var on_replay_saved = (err) => {
            if (err) {
                this.logger_.error("Could not save a replay to the database: " + err);
                return res.render("errors/500");
            }
            else {
                res.redirect("/replay/" + replay_id);
            }
        }

        // Called once the upload is done
        var on_upload = (err) => {
            if (err) {
                res.render("errors/500");
            }
            else {
                var replay = {
                    id: replay_id,
                    title: replay_title,
                    description: replay_description,
                    link: replay_link
                };

                this.replays_.insert(replay_id, replay, on_replay_saved);
            }
        };

        // Called once the rename is done
        var on_rename = (err) => {
            if (err) {
                this.logger_.error("Could not rename file from \"" + req.file.path + "\" to \"" + replay_path + "\": " + err);
                res.render("errors/500");
            }
            else {
                this.storage_.upload(replay_path, replay_id + ".osr", on_upload);
            }
        };

        fs.rename(req.file.path, replay_path, on_rename);
    }

    /**
     * Shows a replay
     *
     * @param req Express request object
     * @param res Express response object
     */
    show = (req: Request, res: Response) => {
        this.replays_.find(req.params.id, (err, replay) => {
            if (err) {
                this.logger_.error("Could not retrieve replay with id \"" + req.params.id + "\" from the database: " + err);
                res.render("errors/500");
            }
            else if (!replay) {
                this.logger_.warning("Replay with id \"" + req.params.id + "\" does not exist in the database");
                res.render("errors/404");
            }
            else {
                res.render("replay", { replay: replay });
            }
        });
    }

    /**
     * @inheritdoc
     */
    install(application: Application) {
        application.post("/replay", this.upload_.single("file"), this.create);

        application.get("/replay/:id", this.show);

        this.logger_.success("ReplaysController successfully installed");
    }
}

/**
 * Exports
 */
export default IReplaysController;
