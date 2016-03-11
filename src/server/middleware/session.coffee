module.exports = class SessionMiddleware
    dependencies: -> ["session"]

    install: (app) ->

        params =
            secret: "rWaFxfe:%Zd`}CKm[-6@No#(8uPc]_",
            resave: false,
            saveUninitialized: false

        app.use @session params
