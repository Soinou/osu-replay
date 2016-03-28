var child_process = require("child_process");
var gulp = require("gulp");
var gulpif = require("gulp-if");
var gutil = require("gulp-util");
var plumber = require("gulp-plumber");
var Promise = require("promise");
var sass = require("gulp-sass");
var uglify = require("gulp-uglify");

module.exports = function (release, build) {
    return {
        exec: function (command) {
            return new Promise(function (resolve, reject) {
                var child = child_process.exec(command);

                child.stdout.pipe(process.stdout);
                child.stderr.pipe(process.stderr);

                child.on("exit", resolve);
            });
        },

        error: function (name) {
            return function (err) {
                gutil.log(gutil.colors.red("[Error]"), "'" + gutil.colors.cyan(name) + "':", err.toString());
                this.emit("end");
            }
        },

        plumber: function (name) {
            return plumber({ handleError: this.error(name) });
        },

        sass: function () {
            options = {
                outputStyle: release ? "compressed" : "nested"
            };

            return sass(options).on("error", this.error("sass"));
        },

        uglify: function () {
            return gulpif(release, uglify());
        },

        bin: function (path) {
            if (release)
                return "../bin/Release/" + path;
            else
                return "../bin/Debug/" + path;
        },

        dest: function (path) {
            return gulp.dest(this.bin(path));
        },

        task: function (name, dependencies, buildDependencies, execute) {
            var error = this.error;

            if (build) dependencies = dependencies.concat(buildDependencies);

            gulp.task(name, dependencies, function (callback) {
                execute().then(function () { callback(); }).catch(error(name));
            });
        }
    }
};
