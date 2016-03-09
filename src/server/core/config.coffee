module.exports = class Config

    dependencies: -> ["shortid"]

    initialized: ->
        @shortid.characters "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$+"
