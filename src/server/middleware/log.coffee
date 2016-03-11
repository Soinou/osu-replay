module.exports = class LogMiddleware
    dependencies: -> ["logger", "on_finished", "on_headers", "util"]

    install: (app) ->

        app.use (req, res, next) =>

            req._start = process.hrtime()

            @on_headers res, -> res._start = process.hrtime()

            @on_finished res, (err, res) =>

                method = req.method
                url = req.originalUrl or req.url
                status = if res._header? then String res.statusCode else undefined
                first = (res._start[0] - req._start[0]) * 1e3
                second = (res._start[1] - req._start[1]) * 1e-6
                time = (first + second).toFixed 3
                @logger.debug @util.format "%s %s %s %sms", method, url, status, time

            next()
