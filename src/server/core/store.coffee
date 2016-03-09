class MongoStore

    dependencies: -> [
        "logger",
        "mongojs",
        "Promise"
        "util",
    ]

    constructor: (@name_) ->

    initialized: ->
        url = @util.format "%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH

        @collection_ = @mongojs(url, [@name_]).collection @name_

        @logger.debug "Created new MongoStore '" + @name_ + "'"

    all: ->
        return new @Promise (resolve, reject) =>
            @collection_.find (err, docs) ->
                if err then reject err else resolve docs

    find: (id) ->
        return new @Promise (resolve, reject) =>
            @collection_.findOne _id: id, (err, doc) ->
                if err then reject err else resolve doc

    insert: (id, value) ->
        value._id = id
        return new @Promise (resolve, reject) =>
            @collection_.insert value, (err) ->
                if err then reject err else resolve value

    update: (id, value) ->
        value._id = id
        return new @Promise (resolve, reject) =>
            @collection_.update _id: id, value, (err) ->
                if err then reject err else resolve value

    delete: (id) ->
        return new @Promise (resolve, reject) =>
            @collection_.remove _id: id, (err) ->
                if err then reject err else resolve()

class LocalStore

    dependencies: -> [
        "Dict",
        "logger",
        "Promise",
        "util"
    ]

    constructor: (@name_) ->

    initialized: ->
        @collection_ = @Dict.create()
        @logger.debug "Created new LocalStore '" + @name_ + "'"

    all: -> @Promise.resolve @collection_.values()

    find: (id) ->
        value = @collection_.get id, null
        if value? then value = @util._extend {}, value
        return @Promise.resolve value

    insert: (id, value) ->
        value._id = id
        @collection_.set id, value
        return @Promise.resolve value

    update: (id, value) ->
        value._id = id
        @collection_.set id, value
        return @Promise.resolve value

    delete: (id) ->
        @collection_.delete id
        return @Promise.resolve()

if process.env.NODE_ENV is "production"
    module.exports = MongoStore
else
    module.exports = LocalStore
