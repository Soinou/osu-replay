import kernel from "./Kernel";
import IApplication from "./core/Application";

// Get the application from the kernel
var application = kernel.resolve<IApplication>("IApplication");

// Setup application
application.setup();

// Then start it
application.start();
