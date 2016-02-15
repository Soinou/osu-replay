browserify = require "browserify"
fs = require "fs-extra"
child_process = require "child_process"

exports = module.exports = class StartCommand

    constructor: (@logger_) ->

    bundle_libs: ->
        b = browserify()

        b.add "resources/vendor/jquery/dist/jquery.js"
        b.add "resources/vendor/bootstrap/dist/js/bootstrap.js"

        b.plugin "minifyify", map: false
        b.transform "browserify-shim"

        stream = fs.createWriteStream "public/build/js/lib.js"

        b.bundle().pipe(stream).on "close", () =>
            @logger_.success "Javascript libraries compiled"

    bundle_iced: (name) ->
        directory = "resources/iced/" + name

        if not fs.statSync(directory).isDirectory() then return

        if not fs.existsSync directory + "/index.iced" then return

        b = browserify()

        b.add directory + "/index.iced"

        b.plugin "minifyify", map: false
        b.transform "icsify"

        stream = fs.createWriteStream "public/build/js/" + name + ".js"

        b.bundle().pipe(stream).on "close", () =>
            @logger_.success "Javascript compiled"

    bundle_sass: ->
        fs.copySync "resources/vendor/bootstrap/dist/css/bootstrap.css.map", "public/build/css/bootstrap.css.map"

        args = [
            "node",
            "node_modules/node-sass/bin/node-sass",
            "--output-style", "compressed",
            "-o", "public/build/css",
            "resources/sass/app.sass"
        ]

        command = args.join " "

        child_process.exec command, (error, stdout, stderr) =>
            if error?
                @logger_.error error
            else
                @logger_.success "CSS compiled"

    run: ->
        fs.ensureDirSync "public/build/js"

        fs.readdir "resources/iced", (err, directories) =>
            if err then throw err

            for directory in directories
                @bundle_iced directory

        @bundle_libs()

        @bundle_sass()

exports["@require"] = [ "logger" ]

