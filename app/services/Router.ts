import { Application } from "express";

import { Inject } from "inversify";

import IReplaysController from "../controllers/Replays";

/**
 * Represents a router, setting up routes to an express application
 */
interface IRouter {
    /**
     * Installs all the routes to the given express Application
     */
    install(application: Application);
}

/**
 * Implementation of the IRouter interface
 */
@Inject("IReplaysController")
export class Router {
    /**
     * Creates a new Router
     */
    constructor(protected replays_: IReplaysController) {

    }

    /**
     * @inheritdoc
     */
    install(application: Application) {
        this.replays_.install(application);
    }
}

/**
 * Exports
 */
export default IRouter;
