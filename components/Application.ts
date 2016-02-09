import * as bodyParser from "body-parser";
import * as dotenv from "dotenv";
import * as express from "express";
import * as IoC from "electrolyte";
import * as fs from "fs";
import * as mongoose from "mongoose";
import * as morgan from "morgan";
import * as util from "util";

import Logger from "./Logger";

// Export the application
export default class Application
{
    // Logger
    _logger: Logger;
    _app: express.Application;

    // Constructor
    constructor(logger)
    {
        this._logger = logger;
        this._app = express();
    }

    public setup()
    {
        this._logger.info("Initializing Application...");

        if(!fs.existsSync(".env"))
        {
            fs.linkSync(".env.example", ".env");
            this._logger.fatal("Please setup the .env file");
        }

        dotenv.config();

        this._app.set("view engine", "jade");
        this._app.use(express.static("public"));
        this._app.use(morgan("dev"));
        this._app.use(bodyParser.urlencoded({ extended: false }));
        this._app.use(bodyParser.json());

        this._app.get("/", (req, res) =>
        {
            res.render("home");
        });

        // Load controllers
        IoC.create("ReplaysController").install(this._app);

        this._logger.info("Application successfully initialized");
    }

    public start()
    {
        this._logger.info("Starting Application...");

        mongoose.connect(this.url(), (err) =>
        {
            if(err)
            {
                this._logger.fatal("Could not connect to MongoDB database: " + err);
            }
            else
            {
                var port = process.env.PORT || 5000;

                this._app.listen(port, (err) =>
                {
                    this._logger.info("Application listening on port " + port);
                });
            }
        });
    }

    private url()
    {
        return util.format("mongodb://%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH
        );
    }
}

// Electrolyte exports
exports = module.exports = Application;
exports["@singleton"] = true;
exports["@require"] = [ "Logger" ];
