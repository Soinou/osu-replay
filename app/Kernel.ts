import { TypeBinding, Kernel, TypeBindingScopeEnum } from "inversify";

// Controllers
import IReplaysController, { ReplaysController } from "./controllers/Replays";

// Core
import IApplication, { Application } from "./core/Application";

// Models
import IReplay, { Replay } from "./models/Replay";

// Services
import ILogger, { Logger } from "./services/Logger";
import IRouter, { Router } from "./services/Router";
import IStorage, { S3Storage, LocalStorage } from "./services/Storage";

// Create a new kernel
var kernel = new Kernel();

// Bind all the controllers (Controllers should only used by the router)
kernel.bind(new TypeBinding<IReplaysController>("IReplaysController", ReplaysController));

// Bind all the core components (Application should only be created once)
kernel.bind(new TypeBinding<IApplication>("IApplication", Application));

// Bind all the models (Could be a great idea to use sqlite or a json storage for local development)
kernel.bind(new TypeBinding<IReplay>("IReplay", Replay, TypeBindingScopeEnum.Singleton));

// Bind all the services
kernel.bind(new TypeBinding<ILogger>("ILogger", Logger, TypeBindingScopeEnum.Singleton));
kernel.bind(new TypeBinding<IRouter>("IRouter", Router, TypeBindingScopeEnum.Singleton));

// Change the storage type if we're on production
if (process.env.NODE_ENV == "production") {
    kernel.bind(new TypeBinding<IStorage>("IStorage", S3Storage, TypeBindingScopeEnum.Singleton));
}
else {
    kernel.bind(new TypeBinding<IStorage>("IStorage", LocalStorage, TypeBindingScopeEnum.Singleton));
}


// Export the kernel
export default kernel;
