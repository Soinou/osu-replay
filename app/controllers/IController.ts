import * as express from "express";

/**
 * Base controller interface
 */
interface IController {
    /**
     * Installs the controller to the given application
     *
     * @param aplication The express application we need to install routes on
     */
    install(application: express.Application);
}

/**
 * Default export
 */
export default IController;
