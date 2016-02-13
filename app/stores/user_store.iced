{make_esc} = require "iced-error"

exports = module.exports = class UserStore

    constructor: (@api_, store) ->
        @store_ = store.create "users"

    get: (key, callback) ->
        esc = make_esc callback
        await @store_.find key, esc(defer(user))
        if not user?
            await @api_.get_users u: key, esc(defer(users))
            if users.length > 0
                user = users[0]
            await @store_.insert key, user, esc(defer())
        callback null, user

exports["@singleton"] = true
exports["@require"] = [ "api", "store" ]
