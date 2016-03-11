module.exports = class Config

    dependencies: -> ["fs", "dotenv", "logger", "shortid"]

    initialized: ->
        if process.env.NODE_ENV isnt "staging"
            if not @fs.existsSync ".env"
                @fs.copySync ".env.example", ".env"
                @logger.fatal "Please setup the .env file"
            @dotenv.config()

        @shortid.characters "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$+"
