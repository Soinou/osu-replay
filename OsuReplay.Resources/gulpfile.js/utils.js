var gulp = require("gulp");
var gulpif = require("gulp-if");
var gutil = require("gulp-util");
var plumber = require("gulp-plumber");
var sass = require("gulp-sass");
var uglify = require("gulp-uglify");

module.exports = {
    production: process.env.NODE_ENV === "production",

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
            outputStyle: "compressed"
        };

        return sass(options).on("error", this.error("sass"));
    },

    uglify: function () {
        return gulpif(this.production, uglify());
    },

    bin: function (path) {
        if (this.production)
            return "../bin/Release/" + path;
        else
            return "../bin/Debug/" + path;
    },

    dest: function (path) {
        return gulp.dest(this.bin(path));
    }
};
