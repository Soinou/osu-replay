exports = module.exports = class StartCommand

    constructor: (@logger_) ->

    run: ->
        @logger_.info "Hello World!"

exports["@require"] = [ "logger" ]
