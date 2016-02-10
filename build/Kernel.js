import { TypeBinding, Kernel, TypeBindingScopeEnum } from "inversify";
import { ReplaysController } from "./controllers/Replays";
import { Application } from "./core/Application";
import { ReplayRepository } from "./models/ReplayRepository";
import { Logger } from "./services/Logger";
import { Router } from "./services/Router";
import { MongoDBDatabase, LocalDatabase } from "./services/Database";
import { S3Storage, LocalStorage } from "./services/Storage";
// Create a new kernel
var kernel = new Kernel();
// Bind all the controllers (Controllers should only used by the router)
kernel.bind(new TypeBinding("IReplaysController", ReplaysController));
// Bind all the core components (Application should only be created once)
kernel.bind(new TypeBinding("IApplication", Application));
// Bind all the models repositories
kernel.bind(new TypeBinding("IReplayRepository", ReplayRepository, TypeBindingScopeEnum.Singleton));
// Bind all the services
kernel.bind(new TypeBinding("ILogger", Logger, TypeBindingScopeEnum.Singleton));
kernel.bind(new TypeBinding("IRouter", Router, TypeBindingScopeEnum.Singleton));
// Change some implementations on production
if (process.env.NODE_ENV == "production") {
    kernel.bind(new TypeBinding("IDatabase", MongoDBDatabase, TypeBindingScopeEnum.Singleton));
    kernel.bind(new TypeBinding("IStorage", S3Storage, TypeBindingScopeEnum.Singleton));
}
else {
    kernel.bind(new TypeBinding("IDatabase", LocalDatabase, TypeBindingScopeEnum.Singleton));
    kernel.bind(new TypeBinding("IStorage", LocalStorage, TypeBindingScopeEnum.Singleton));
}
export default kernel;
//# sourceMappingURL=Kernel.js.map