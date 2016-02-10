import * as bodyParser from "body-parser";
import * as express from "express";
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
        this.app_.set("view engine", "jade");
        this.app_.use(express.static("public"));
        this.app_.use(morgan("dev"));
        this.app_.use(bodyParser.urlencoded({ extended: false }));
        this.app_.use(bodyParser.json());

        this.app_.get("/", (req, res) => {
            res.render("home");
        });

        this.router_.install(this.app_);

        this.logger_.success("Application successfully initialized");
    }

    /**
     * @inheritdoc
     */
    public start() {
        var port = process.env.PORT || 5000;

        this.app_.listen(port, (err) => {
            this.logger_.success("Application listening on port " + port);
        });
    }
}

// Exports
export default IApplication;
