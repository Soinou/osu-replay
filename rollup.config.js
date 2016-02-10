import babel from "rollup-plugin-babel";
import uglify from "rollup-plugin-uglify";

export default {
    entry: "build/main.js",
    dest: "bin/www",
    format: "cjs",
    sourceMap: true,
    plugins: [babel(), uglify()],
    external: [
        "body-parser",
        "chalk",
        "collections/dict",
        "dotenv",
        "express",
        "fs",
        "fs-extra",
        "inversify",
        "moment",
        "mongodb",
        "morgan",
        "multer",
        "os",
        "s3",
        "util",
    ]
};
