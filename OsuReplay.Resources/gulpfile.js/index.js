var gulp = require("gulp");

require("require-dir")("./tasks");

gulp.task("default", ["client"]);

gulp.task("watch", ["client:watch"]);
