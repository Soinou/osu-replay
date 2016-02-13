https = require "https"
process = require "process"
{make_esc} = require "iced-error"

kApiUrl = "https://osu.ppy.sh/api"

# Wrapper around the osu! api
exports = module.exports = class Api

    # Creates a new Api wrapper
    constructor: (@logger_) ->
        @key_ = process.env.OSU_API_KEY

    # Get beatmaps from the api
    get_beatmaps: (params, callback) ->
        url = kApiUrl + "/get_beatmaps?k=" + @key_
        params = params or {}
        # Order is hash > beatmap_id > set_id > user_id > big black
        if params.h?
            url += "&h=" + params.h
        else if params.b?
            url += "&b=" + params.b
        else if params.s?
            url += "&s=" + params.s
        else if params.u?
            url += "&u=" + params.u
            url += "&type=" + (params.type or "string")
        else
            url += "&s=41823"
        # Game mode (Defaults to standard)
        url += "&m=" + (params.m or "0")
        # Converted (Defaults to no)
        url += "&a=" + (params.a or "0")
        # Limit (Defaults to 500)
        url += "&limit=" + (params.limit or "500")
        @_get url, callback

    # Get only one beatmap from the api
    get_beatmap: (params, callback) ->
        esc = make_esc callback
        await @get_beatmaps params, esc(defer(beatmap))
        if beatmap? and beatmap.length > 0
            beatmap = beatmap[0]
        callback null, beatmap

    # Get users from the api
    get_users: (params, callback) ->
        url = kApiUrl + "/get_user?k=" + @key_
        params = params or {}
        # User id (Either string or id, defaults to ciel de la nuit)
        url += "&u=" + (params.u or "ciel_de_la_nuit")
        # Game mode (Defaults to standard)
        url += "&m=" + (params.m or "0")
        # User id type (Defaults to string)
        url += "&type=" + (params.type or "string")
        # Event days (Defaults to one)
        url += "&event_days=" + (params.event_days or "1")
        @_get url, callback

    # Get only one user from the api
    get_user: (params, callback) ->
        esc = make_esc callback
        await @get_users params, esc(defer(user))
        if user? and user.length > 0
            user = user[0]
        callback null, user

    # Internal get
    _get: (url, callback) ->
        success = (res) =>
            if res.statusCode isnt 200
                message = "osu!api returned status: " + res.statusCode
                @logger_.error message
                callback message, null
            else
                @logger_.debug "osu!api request finished, reading data"
                data = ""
                res.on "data", (chunk) ->
                    data += chunk
                res.on "end", () =>
                    @logger_.debug "Data read, sending parsed data back"
                    callback null, JSON.parse data
        error = (err) =>
            @logger_.error "osu!api request returned an error: " + err
            callback err, null
        @logger_.debug "Sending osu!api request to \"" + url + "\""
        https.get(url, success).on "error", error

exports["@singleton"] = true;
exports["@require"] = [ "logger" ]
