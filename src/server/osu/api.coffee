# Wrapper around the osu! api
module.exports = class Api

    dependencies: -> ["https", "logger", "Promise"]

    constructor: ->
        @api_url_ = "https://osu.ppy.sh/api"
        @key_ = process.env.OSU_API_KEY

    # Get beatmaps from the api
    get_beatmaps: (params) ->
        url = @api_url_ + "/get_beatmaps?k=" + @key_
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
        return @_get url

    # Get only one beatmap from the api
    get_beatmap: (params) ->
        @get_beatmaps(params).then (beatmaps) =>
            if not beatmaps? or beatmaps.length is 0
                throw new Error "osu!api returned empty data"
            else return @Promise.resolve beatmaps[0]

    # Get users from the api
    get_users: (params) ->
        url = @api_url_ + "/get_user?k=" + @key_
        params = params or {}
        # User id (Either string or id, defaults to ciel de la nuit)
        url += "&u=" + (params.u or "ciel_de_la_nuit")
        # Game mode (Defaults to standard)
        url += "&m=" + (params.m or "0")
        # User id type (Defaults to string)
        url += "&type=" + (params.type or "string")
        # Event days (Defaults to one)
        url += "&event_days=" + (params.event_days or "1")
        return @_get url

    # Get only one user from the api
    get_user: (params, callback) ->
        @get_users(params).then (users) =>
            if not users? or users.length is 0
                throw new Error "osu!api returned empty data"
            else return @Promise.resolve users[0]

    # Internal get
    _get: (url) ->
        return new @Promise (resolve, reject) =>

            success = (res) =>
                if res.statusCode isnt 200
                    message = "osu!api returned status: " + res.statusCode
                    @logger.error message
                    reject message
                else
                    @logger.debug "osu!api request finished, reading data"
                    data = ""
                    res.on "data", (chunk) ->
                        data += chunk
                    res.on "end", () =>
                        @logger.debug "Data read, sending parsed data back"
                        value = JSON.parse data
                        if not value then reject "osu!api returned empty data"
                        else resolve value

            error = (err) =>
                @logger.error "osu!api request returned an error: ", err
                reject err

            @logger.debug "Sending osu!api request to \"" + url + "\""

            @https.get(url, success).on "error", error
