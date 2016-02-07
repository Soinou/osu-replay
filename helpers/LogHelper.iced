chalk = require "chalk"
fs = require "fs"
moment = require "moment"
os = require "os"

# A little log helper
module.exports = class LogHelper

	constructor: (@application) ->

        @application.success = @success
        @application.info = @info
        @application.warning = @warning
        @application.error = @error
        @application.fatal = @fatal

	_log: (message, status, color) ->
        timestamp = moment().format("HH:mm:ss")
        console.log timestamp + " [" + color(status) + "] " + message
        fs.appendFileSync "logs/" + moment().format("YYYY-MM-DD") + ".log", timestamp + " [" + status + "] " + message + os.EOL

	success: (message) =>
		@_log message, "Success", chalk.green

	info: (message) =>
		@_log message, "Info", chalk.cyan

	warning: (message) =>
		@_log message, "Warning", chalk.yellow

	error: (message) =>
		@_log message, "Error", chalk.red

	fatal: (message) =>
		@_log message, "Fatal", chalk.blue.bgRed
		process.exit 1