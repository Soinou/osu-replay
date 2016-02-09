import * as IoC from "electrolyte";

// Directories where we can load modules from
IoC.use(IoC.node("bin/components"));
IoC.use(IoC.node("bin/controllers"));
IoC.use(IoC.node("bin/models"));

// Load the application
var application = IoC.create("Application");

// Setup application
application.setup();

// Then start it
application.start();
