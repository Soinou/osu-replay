chalk = require "chalk"
fs = require "fs"
moment = require "moment"
os = require "os"
process = require "process"

# Logs directory
kDirectory = "logs"

# Represents a simple logger
class Logger

    # Creates a new Logger
    constructor: () ->
        if not fs.existsSync kDirectory
            fs.mkdirSync kDirectory

    # Internal logging
    # Logs to a log file and to the console
    _log: (message, status, color) ->
        process.nextTick () ->
            hour = moment().format "HH:mm:ss"
            day = moment().format "YYYY-MM-DD"
            file = kDirectory + "/" + day + ".log"
            colored = hour + " [" + color(status) + "] " + message
            uncolored = hour + " [" + status + "] " + message + os.EOL
            console.log colored
            fs.appendFile file, uncolored, (err) ->
                if err
                    console.log "Error when writing to the log file: " + err

    # Logs a debug message (Level 0)
    debug: (message) ->
        if process.env.LOG_LEVEL > 0 then return
        @_log message, "Debug", chalk.magenta

    # Logs an info message (Level 1)
    info: (message) ->
        if process.env.LOG_LEVEL > 1 then return
        @_log message, "Info", chalk.cyan

    # Logs a success message (Level 2)
    success: (message) ->
        if process.env.LOG_LEVEL > 2 then return
        @_log message, "Success", chalk.green

    # Logs a warning message (Level 3)
    warning: (message) ->
        if process.env.LOG_LEVEL > 3 then return
        @_log message, "Warning", chalk.yellow

    # Logs an error message (Level 4)
    error: (message) ->
        if process.env.LOG_LEVEL > 4 then return
        @_log message, "Error", chalk.red

    # Logs a fatal message (Level 5)
    fatal: (message) ->
        if process.env.LOG_LEVEL > 5 then return
        @_log message, "Fatal", chalk.red.underline
        process.exit 0

# Exports
exports = module.exports = Logger
exports["@singleton"] = true
