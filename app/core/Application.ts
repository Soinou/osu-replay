import * as bodyParser from "body-parser";
import * as dotenv from "dotenv";
import * as express from "express";
import * as fs from "fs";
import * as mongoose from "mongoose";
import * as morgan from "morgan";
import * as util from "util";

import ILogger from "../services/Logger";
import IRouter from "../services/Router";

import { Inject } from "inversify";

/**
 * Defines an application interface
 */
export interface IApplication {
    /**
     * Setups the application
     */
    setup();

    /**
     * Starts the application
     */
    start();
}

/**
 * Implementation of the IApplication
 */
@Inject("ILogger", "IRouter")
export class Application implements IApplication {
    /**
     * The logger used
     */
    protected app_: express.Application;

    /**
     * Creates a new Application
     *
     * @param logger_ Logger service
     * @param router_ Router service
     */
    constructor(protected logger_: ILogger, protected router_: IRouter) {
        this.app_ = express();
    }

    /**
     * @inheritdoc
     */
    public setup() {
        this.logger_.info("Initializing Application...");

        if (!fs.existsSync(".env")) {
            fs.linkSync(".env.example", ".env");
            this.logger_.warning("Please setup the .env file");
        }

        dotenv.config();

        this.app_.set("view engine", "jade");
        this.app_.use(express.static("public"));
        this.app_.use(morgan("dev"));
        this.app_.use(bodyParser.urlencoded({ extended: false }));
        this.app_.use(bodyParser.json());

        this.app_.get("/", (req, res) => {
            res.render("home");
        });

        this.router_.install(this.app_);

        this.logger_.info("Application successfully initialized");
    }

    /**
     * @inheritdoc
     */
    public start() {
        this.logger_.info("Starting Application...");

        mongoose.connect(this.url(), (err) => {
            if (err) {
                this.logger_.fatal("Could not connect to MongoDB database: " + err);
            }
            else {
                var port = process.env.PORT || 5000;

                this.app_.listen(port, (err) => {
                    this.logger_.info("Application listening on port " + port);
                });
            }
        });
    }

    private url() {
        return util.format("mongodb://%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH
        );
    }
}

// Exports
export default IApplication;
