Dict = require "collections/dict"
extend = require("util")._extend
mongojs = require "mongojs"
process = require "process"
{make_esc} = require "iced-error"
util = require "util"

class MongoStore

    constructor: (name) ->

        url = util.format "%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH

        @collection_ = mongojs(url, [name]).collection name

    find: (id, callback) ->
        @collection_.findOne _id: id, callback

    insert: (id, value, callback) ->
        value._id = id
        @collection_.insert value, callback

    update: (id, value, callback) ->
        value._id = id
        @collection_.update _id: id, value, callback

    delete: (id, callback) ->
        @collection_.remove _id: id, callback

class LocalStore

    constructor: (name) ->
        @collection_ = new Dict

    find: (id, callback) ->
        value = @collection_.get(id, null)
        if value? then value = extend {}, value
        callback null, value

    insert: (id, value, callback) ->
        value._id = id
        @collection_.set id, value
        callback null

    update: (id, value, callback) ->
        value._id = id
        @collection_.set id, value
        callback null

    delete: (id, callback) ->
        @collection_.delete id
        callback null

# Store factory
exports = module.exports = class StoreFactory

    constructor: (@logger_) ->

    create: (name) ->
        if process.env.NODE_ENV == "production"
            @logger_.debug "Created new MongoStore \"" + name + "\""
            return new MongoStore name
        else
            @logger_.debug "Created new LocalStore \"" + name + "\""
            return new LocalStore name

exports["@singleton"] = true
exports["@require"] = [ "logger" ]
