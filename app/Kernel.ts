import * as dotenv from "dotenv";
import * as fs from "fs-extra";
import { Kernel, TypeBinding, TypeBindingScopeEnum } from "inversify";
import IReplaysController, { ReplaysController } from "./controllers/Replays";
import IApplication, { Application } from "./core/Application";
import IReplayRepository, { MongoReplayRepository, LocalReplayRepository } from "./repositories/ReplayRepository";
import ILogger, { Logger } from "./services/Logger";
import IRouter, { Router } from "./services/Router";
import IStorage, { S3Storage, LocalStorage } from "./services/Storage";

// Create a new kernel
var kernel = new Kernel();

// Bind the logger
kernel.bind(new TypeBinding<ILogger>("ILogger", Logger, TypeBindingScopeEnum.Singleton));

// And take it out
var logger = kernel.resolve<ILogger>("ILogger");

if (!fs.existsSync(".env")) {
    fs.copySync(".env.example", ".env");

    if (process.env.NODE_ENV != "production") {
        logger.fatal("Please setup the .env file");
    }
    else {
        logger.warning("Please setup the .env file");
    }
}

// Configure dotenv using the .env file
// We need to do it here because it might override the NODE_ENV variable
dotenv.config();

// Bind all the controllers (Controllers should only used by the router)
kernel.bind(new TypeBinding<IReplaysController>("IReplaysController", ReplaysController));

// Bind all the core components (Application should only be created once)
kernel.bind(new TypeBinding<IApplication>("IApplication", Application));

// Bind all the services

kernel.bind(new TypeBinding<IRouter>("IRouter", Router, TypeBindingScopeEnum.Singleton));

// Change some implementations on production
if (process.env.NODE_ENV == "production") {
    kernel.bind(new TypeBinding<IReplayRepository>("IReplayRepository", MongoReplayRepository, TypeBindingScopeEnum.Singleton));
    kernel.bind(new TypeBinding<IStorage>("IStorage", S3Storage, TypeBindingScopeEnum.Singleton));
}
else {
    kernel.bind(new TypeBinding<IReplayRepository>("IReplayRepository", LocalReplayRepository, TypeBindingScopeEnum.Singleton));
    kernel.bind(new TypeBinding<IStorage>("IStorage", LocalStorage, TypeBindingScopeEnum.Singleton));
}

logger.success("Kernel loaded successfully");

// Export the kernel
export default kernel;
