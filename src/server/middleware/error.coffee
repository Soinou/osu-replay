module.exports = class ErrorMiddleware

    dependencies: -> ["logger"]

    install: (app) ->
        app.use (err, req, res, next) =>
            @logger.error "Application error:", err
            res.sendfile "public/error.html"
