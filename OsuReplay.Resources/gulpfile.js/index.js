var argv = require("yargs").argv;
var browserify = require("browserify");
var buffer = require("vinyl-buffer");
var concat = require("gulp-concat");
var fs = require("fs-extra-promise");
var gulp = require("gulp");
var jade = require("gulp-jade");
var path = require("path");
var Promise = require("promise");
var coffeeify = require("coffee-reactify");
var source = require("vinyl-source-stream");
var utils = require("./utils")(argv.Release, argv.build);

// Compiles the client javascript
utils.task("app", [], ["install"], function () {
    return new Promise(function (resolve, reject) {
        var options = {
            entries: "client/index.cjsx",
            paths: ["node_modules", "client"]
        }

        browserify(options)
            .transform(coffeeify)
            .bundle()
            .on("error", reject)
            .pipe(utils.plumber("app"))
            .pipe(source("app.js"))
            .pipe(buffer())
            .pipe(utils.uglify())
            .pipe(utils.dest("public/js"))
            .on("end", resolve);
    });
});

// Copies fonts/images/Configuration.xml to the output directory
utils.task("assets", [], ["install"], function () {
    var actions = [];

    fs.ensureDirSync(utils.bin("public"));
    actions.push(fs.copyAsync("fonts", utils.bin("public/fonts")));
    actions.push(fs.copyAsync("images", utils.bin("public/img")));
    if (!fs.existsSync(utils.bin("Configuration.xml")))
        actions.push(fs.copyAsync("Configuration.xml", utils.bin("Configuration.xml")));

    return Promise.all(actions);
});

// Installs the bower components
utils.task("bower", [], ["install"], function () {
    return utils.exec("node node_modules/bower/bin/bower install");
});

// Cleans everything
utils.task("clean", [], [], function () {
    return fs.removeAsync(utils.bin("public"));
});

// Installs the node modules
utils.task("install", [], [], function () {
    return utils.exec("npm install");
});

// Compiles the client js libraries
utils.task("lib", ["bower"], ["install"], function () {
    return new Promise(function (resolve, reject) {
        var files = [
            "style/vendor/jquery/dist/jquery.js",
            "style/vendor/bootstrap/dist/js/bootstrap.js"
        ];

        gulp.src(files)
            .on("error", reject)
            .pipe(utils.plumber("lib"))
            .pipe(concat("lib.js"))
            .pipe(utils.uglify())
            .pipe(utils.dest("public/js"))
            .on("end", resolve);
    });
});

// Compiles the sass files
utils.task("style", ["bower"], ["install"], function () {
    return new Promise(function (resolve, reject) {
        gulp.src("style/app.sass")
            .on("error", reject)
            .pipe(utils.plumber("style"))
            .pipe(utils.sass())
            .pipe(utils.dest("public/css"))
            .on("end", resolve);
    });
});

// Compiles the jade views
utils.task("views", [], ["install"], function () {
    return new Promise(function (resolve, reject) {
        gulp.src("views/*.jade")
            .on("error", reject)
            .pipe(utils.plumber("views"))
            .pipe(jade())
            .pipe(utils.dest("public"))
            .on("end", resolve);
    });
});

// Default task does everything
gulp.task("default", ["app", "assets", "lib", "style", "views"]);

// Watch does everything then watches for any changes
gulp.task("watch", ["default"], function () {
    gulp.watch("fonts/**/*", ["assets"]);
    gulp.watch("images/**/*", ["assets"]);
    gulp.watch("views/**/*.jade", ["views"]);
    gulp.watch("style/**/*.sass", ["style"]);
    return gulp.watch(["client/**/*"], ["app"]);
});
