# Client sending messages via osu! IRC
module.exports = class Client

    dependencies: -> ["Deque", "irc_lib", "logger", "Promise"]

    initialized: ->
        @messages_ = @Deque.create()

        server = process.env.IRC_SERVER
        nick = process.env.IRC_NICK
        options =
            autoConnect: false,
            userName: nick,
            password: process.env.IRC_PASSWORD

        @client_ = new @irc_lib.Client server, nick, options

        @client_.addListener "message", @on_message
        @client_.addListener "pm", @on_private_message
        @client_.addListener "error", @on_error

    on_connect: =>
        @interval_ = setInterval @on_interval, 1000

    on_error: (message) =>
        logger.error message

    on_message: (from, to, message) =>
        logger.info "[" + to + "] " + from + ": " + message

    on_private_message: (from, message) =>
        logger.info "[PRIVMSG] " + from + ": " + message

    on_interval: =>
        count = 5
        while @messages_.length > 0 and count-- > 0
            message = @messages_.shift()

            @client_.say message.target, message.content

    join: (channel) ->
        @client_.join channel

    connect: ->
        return new Promise (resolve, reject) =>
            @client_.connect 5, =>
                @on_connect()
                resolve()

    send: (target, content) ->
        @messages_.push { target: target, content: content }
