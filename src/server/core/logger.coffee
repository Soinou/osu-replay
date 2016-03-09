# Represents a simple logger
module.exports = class Logger

    dependencies: -> ["chalk", "fs", "moment", "os"]

    initialized: ->
        @directory_ = "logs"
        if not @fs.existsSync @directory_
            @fs.mkdirSync @directory_

    # Internal logging
    # Logs to a log file and to the console
    _log: (message, status, color, err) ->
        hour = @moment().format "HH:mm:ss"
        day = @moment().format "YYYY-MM-DD"
        file = @directory_ + "/" + day + ".log"
        colored = hour + " [" + color(status) + "] " + message
        uncolored = hour + " [" + status + "] " + message + @os.EOL
        console.log colored
        if err? then console.log err.stack
        @fs.appendFileAsync file, uncolored
        .catch (err) -> console.log "Couldn't write to log file:", err

    # Logs a debug message (Level 0)
    debug: (message, err) ->
        if process.env.LOG_LEVEL > 0 then return
        @_log message, "Debug", @chalk.magenta, err

    # Logs an info message (Level 1)
    info: (message, err) ->
        if process.env.LOG_LEVEL > 1 then return
        @_log message, "Info", @chalk.cyan, err

    # Logs a success message (Level 2)
    success: (message, err) ->
        if process.env.LOG_LEVEL > 2 then return
        @_log message, "Success", @chalk.green, err

    # Logs a warning message (Level 3)
    warning: (message, err) ->
        if process.env.LOG_LEVEL > 3 then return
        @_log message, "Warning", @chalk.yellow, err

    # Logs an error message (Level 4)
    error: (message, err) ->
        if process.env.LOG_LEVEL > 4 then return
        @_log message, "Error", @chalk.red, err

    # Logs a fatal message (Level 5)
    fatal: (message, err) ->
        if process.env.LOG_LEVEL > 5 then return
        @_log message, "Fatal", @chalk.red.underline, err
        process.exit 0
