exports = module.exports = class StartCommand

    constructor: (@application_, @logger_) ->

    run: ->
        try
            @application_.setup()
            @application_.start()
        catch error
            @logger_.error "Unexpected error: "
            @logger_.fatal error.stack

exports["@require"] = [ "application", "logger" ]

