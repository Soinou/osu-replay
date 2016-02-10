var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import * as bodyParser from "body-parser";
import * as dotenv from "dotenv";
import * as express from "express";
import * as fs from "fs-extra";
import * as morgan from "morgan";
import { Inject } from "inversify";
/**
 * Implementation of the IApplication
 */
export let Application = class {
    /**
     * Creates a new Application
     *
     * @param database_ Database service
     * @param logger_ Logger service
     * @param router_ Router service
     */
    constructor(database_, logger_, router_) {
        this.database_ = database_;
        this.logger_ = logger_;
        this.router_ = router_;
        this.app_ = express();
    }
    /**
     * @inheritdoc
     */
    setup() {
        if (!fs.existsSync(".env")) {
            fs.copySync(".env.example", ".env");
            if (process.env.NODE_ENV != "production") {
                this.logger_.fatal("Please setup the .env file");
            }
            else {
                this.logger_.warning("Please setup the .env file");
            }
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
        this.logger_.success("Application successfully initialized");
    }
    /**
     * @inheritdoc
     */
    start() {
        this.database_.connect(() => {
            var port = process.env.PORT || 5000;
            this.app_.listen(port, (err) => {
                this.logger_.success("Application listening on port " + port);
            });
        });
    }
};
Application = __decorate([
    Inject("IDatabase", "ILogger", "IRouter"), 
    __metadata('design:paramtypes', [Object, Object, Object])
], Application);
//# sourceMappingURL=Application.js.map