var coffeelint = require("gulp-coffeelint");
var gulp = require("gulp");
var gutil = require("gulp-util");
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
            gutil.log(gutil.colors.red.underline("Server has stopped"));
        });
    }
};

gulp.task("server:lint", function()
{
    return gulp.src("src/**/*.coffee")
        .pipe(coffeelint("coffeelint.json"))
        .pipe(coffeelint.reporter());
});

gulp.task("server:start", function()
{
    return server.start([
        "node_modules/coffee-script/bin/coffee",
        "src/server/index.coffee",
        "--color"
    ]);
});

gulp.task("server:watch", function()
{
    gulp.watch("src/**/*.coffee", ["server:lint"]);
    return gulp.watch("src/server/**/*", ["server:start"]);
});

gulp.task("server", ["server:lint", "server:start", "server:watch"]);
