var gulp = require("gulp");

require("require-dir")("./tasks");

gulp.task("default", [
    "client",
    "server"
]);

gulp.task("watch", [
    "client:watch",
    "server:watch"
]);
