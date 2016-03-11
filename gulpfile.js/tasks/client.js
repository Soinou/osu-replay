var browserify = require("browserify");
var buffer = require("vinyl-buffer");
var child_process = require("child_process");
var concat = require("gulp-concat");
var gulp = require("gulp");
var jade = require("gulp-jade");
var path = require("path");
var coffeeify = require("coffee-reactify");
var source = require("vinyl-source-stream");
var utils = require("../utils");

gulp.task("client:bower", function(callback)
{
    command = "node node_modules/bower/bin/bower install";

    var child = child_process.exec(command);

    child.stdout.pipe(process.stdout);

    child.on("exit", callback);
});

gulp.task("client:views", function()
{
    return gulp.src("src/views/*.jade")
    .pipe(jade())
    .pipe(gulp.dest("public"));
});

gulp.task("client:style", ["client:bower"], function()
{
    return gulp.src("src/style/app.sass")
        .on("error", utils.error("client:style"))
        .pipe(utils.plumber("client:style"))
        .pipe(utils.sass())
        .pipe(gulp.dest("public/css"));
});

gulp.task("client:lib", ["client:bower"], function()
{
    var files = [
        "src/style/vendor/jquery/dist/jquery.js",
        "src/style/vendor/bootstrap/dist/js/bootstrap.js"
    ];

    return gulp.src(files)
        .on("error", utils.error("client:lib"))
        .pipe(utils.plumber("client:lib"))
        .pipe(concat("lib.js"))
        .pipe(utils.uglify())
        .pipe(gulp.dest("public/js"));
});

gulp.task("client:app", function ()
{
    var options = {
        entries: "src/client/index.cjsx",
        paths: ["node_modules", "src/client"]
    }

    return browserify(options)
        .transform(coffeeify)
        .bundle()
        .on("error", utils.error("client:app"))
        .pipe(utils.plumber("client:app"))
        .pipe(source("app.js"))
        .pipe(buffer())
        .pipe(utils.uglify())
        .pipe(gulp.dest("public/js"));
});

gulp.task("client", [
    "client:views",
    "client:style",
    "client:lib",
    "client:app"
]);

gulp.task("client:watch", ["client"], function()
{
    gulp.watch("src/views/**/*.jade", ["client:views"]);
    gulp.watch("src/style/**/*.sass", ["client:style"]);
    return gulp.watch(["src/client/**/*"], ["client:app"]);
});
