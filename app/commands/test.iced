Mocha = require "mocha"
fs = require "fs-extra"
path = require "path"
iced = require "iced-coffee-script"

iced.register()

process.env.LOG_LEVEL = 6;

exports = module.exports = class StartCommand

    constructor: (@logger_) ->

    run: ->
        mocha = new Mocha

        test_directory = "test"

        filter = (file) -> file.substr(-5) is ".iced"

        fs.readdirSync(test_directory).filter(filter).forEach (file) ->
            mocha.addFile path.join test_directory, file

        mocha.run (failures) ->
            process.exit failures

exports["@require"] = [ "logger" ]
