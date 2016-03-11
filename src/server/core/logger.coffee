# Represents a simple logger
module.exports = class Logger

    @format: "[%s][%s] %s"

    dependencies: -> ["chalk", "fs", "memwatch", "moment", "os", "pretty", "util"]

    initialized: ->
        # Logs directory
        @directory_ = "logs"
        if not @fs.existsSync @directory_
            @fs.mkdirSync @directory_

        switch process.env.NODE_ENV
            # Production and staging both disable colored output
            when "production" then @_log = @_production
            when "staging" then @_log = @_production
            else @_log = @_development

        # Memwatch
        @memwatch.on "leak", (info) =>
            @warning "Memory leak: " + JSON.stringify info
        @memwatch.on "stats", (stats) =>
            @debug "Heap stats: " + JSON.stringify stats

        # Error
        process.on "uncaughtException", (err) =>
            @fatal "Uncaught exception:", err
        process.on "unhandledRejection", (err) =>
            @fatal "Unhandled rejection", err

    _production: (message, status, color, err) =>
        hour = @moment().format "HH:mm:ss"
        day = @moment().format "YYYY-MM-DD"
        file = @directory_ + "/" + day + ".log"

        uncolored = "[" + hour + "]"
        uncolored += "[" + status + "] "
        uncolored += message

        if err? then uncolored += @os.EOL + err.stack

        console.log uncolored
        @fs.appendFileAsync file, uncolored
        .catch (err) =>
            console.log "Couldn't write to log file:", @pretty.render err

    _development: (message, status, color, err) ->
        hour = @moment().format "HH:mm:ss"
        day = @moment().format "YYYY-MM-DD"
        file = @directory_ + "/" + day + ".log"

        colored = "[" + @chalk.grey(hour) + "]"
        colored += "[" + color(status) + "] "
        colored += message

        uncolored = "[" + hour + "]"
        uncolored += "[" + status + "] "
        uncolored += message

        if err?
            colored += @os.EOL + @pretty.render err
            uncolored += @os.EOL + err.stack

        console.log colored
        @fs.appendFileAsync file, uncolored

        .catch (err) =>
            console.log "Couldn't write to log file:", @pretty.render err

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
