var gulp = require("gulp");
var path = require("path");
var spawn = require("child_process").spawn;
var utils = require("../utils");

var server = {
    child: null,

    start: function(arguments)
    {
        if(this.child)
        {
            this.child.kill("SIGTERM");
            this.child = null;
        }

        this.child = spawn("node", arguments);

        // Pipe output
        this.child.stdout.pipe(process.stdout);
        this.child.stderr.pipe(process.stderr);

        // Print something on close
        this.child.on("close", function(code)
        {
            console.log("Server stopped");
        });
    }
};

gulp.task("server:start", function()
{
    server.start([
        "node_modules/coffee-script/bin/coffee",
        "src/server/index.coffee",
        "--color"
    ]);
});

gulp.task("server:watch", function()
{
     return gulp.watch("src/server/**/*", ["server:start"]);
});

gulp.task("server", ["server:start", "server:watch"]);
