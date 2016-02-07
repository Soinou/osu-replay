mongoose = require "mongoose"

module.exports = (app) ->

    schema = mongoose.Schema
        id: String,
        title: String,
        description: String

    schema.virtual("link").get -> app.link this.id + ".osr"

    mongoose.model "Replay", schema
