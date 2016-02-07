mongoose = require "mongoose"

schema = mongoose.Schema
    id: String,
    title: String,
    description: String

schema.virtual("link").get -> "/uploads/" + this.id + ".osr"

module.exports = mongoose.model "Replay", schema
