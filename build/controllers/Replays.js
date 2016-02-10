var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import * as fs from "fs";
import * as multer from "multer";
import { Inject } from "inversify";
/**
 * Implementation of the IReplaysController
 */
export let ReplaysController = class {
    /**
     * Creates a new ReplaysController
     *
     * @param logger_ Logger service
     * @param replays_ Replays repository
     * @param storage_ Storage service
     */
    constructor(logger_, replays_, storage_) {
        this.logger_ = logger_;
        this.replays_ = replays_;
        this.storage_ = storage_;
        /**
         * Creates a new replay
         *
         * @param req Express request object
         * @param res Express response object
         */
        this.create = (req, res) => {
            var replay_id = req.file.filename;
            var replay_title = req.body.title;
            var replay_description = req.body.description;
            var replay_path = req.file.path + ".osr";
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
            };
            // Called once the upload is done
            var on_upload = (err) => {
                if (err) {
                    res.render("errors/500");
                }
                else {
                    var replay = {
                        id: replay_id,
                        title: replay_title,
                        description: replay_description
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
        };
        /**
         * Shows a replay
         *
         * @param req Express request object
         * @param res Express response object
         */
        this.show = (req, res) => {
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
        };
        this.upload_ = multer({ dest: "public/uploads/" });
    }
    /**
     * @inheritdoc
     */
    install(application) {
        application.post("/replay", this.upload_.single("file"), this.create);
        application.get("/replay/:id", this.show);
        this.logger_.success("ReplaysController successfully installed");
    }
};
ReplaysController = __decorate([
    Inject("ILogger", "IReplayRepository", "IStorage"), 
    __metadata('design:paramtypes', [Object, Object, Object])
], ReplaysController);
//# sourceMappingURL=Replays.js.map