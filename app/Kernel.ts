import { TypeBinding, Kernel, TypeBindingScopeEnum } from "inversify";

// Controllers
import IReplaysController, { ReplaysController } from "./controllers/Replays";

// Core
import IApplication, { Application } from "./core/Application";

// Models
import IReplayRepository, { ReplayRepository } from "./models/ReplayRepository";

// Services
import ILogger, { Logger } from "./services/Logger";
import IRouter, { Router } from "./services/Router";
import IDatabase, { MongoDBDatabase, LocalDatabase } from "./services/Database";
import IStorage, { S3Storage, LocalStorage } from "./services/Storage";

// Create a new kernel
var kernel = new Kernel();

// Bind all the controllers (Controllers should only used by the router)
kernel.bind(new TypeBinding<IReplaysController>("IReplaysController", ReplaysController));

// Bind all the core components (Application should only be created once)
kernel.bind(new TypeBinding<IApplication>("IApplication", Application));

// Bind all the models repositories
kernel.bind(new TypeBinding<IReplayRepository>("IReplayRepository", ReplayRepository, TypeBindingScopeEnum.Singleton));

// Bind all the services
kernel.bind(new TypeBinding<ILogger>("ILogger", Logger, TypeBindingScopeEnum.Singleton));
kernel.bind(new TypeBinding<IRouter>("IRouter", Router, TypeBindingScopeEnum.Singleton));

// Change some implementations on production
if (process.env.NODE_ENV == "production") {
    kernel.bind(new TypeBinding<IDatabase>("IDatabase", MongoDBDatabase, TypeBindingScopeEnum.Singleton));
    kernel.bind(new TypeBinding<IStorage>("IStorage", S3Storage, TypeBindingScopeEnum.Singleton));
}
else {
    kernel.bind(new TypeBinding<IDatabase>("IDatabase", LocalDatabase, TypeBindingScopeEnum.Singleton));
    kernel.bind(new TypeBinding<IStorage>("IStorage", LocalStorage, TypeBindingScopeEnum.Singleton));
}

// Export the kernel
export default kernel;
