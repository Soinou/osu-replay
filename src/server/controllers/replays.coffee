# Represents a replays controller
module.exports = class ReplaysController

    dependencies: -> ["fs", "logger", "logger", "replays", "rules", "shortid"]

    # Installs the controller to the given express app
    install: (app) ->
        app.io.route "replays", {get: @_get, create: @_create}

        @logger.debug "ReplaysController installed"

    # replays:get
    _get: (req) =>
        # Get the replay id
        key = req.data or ""

        @logger.debug "Searching for replay \"" + key + "\""
        @replays.get key
        .then (replay) => req.io.emit "replays:got", replay
        .catch (err) =>
            req.io.emit "replays:got", null
            @logger.error "Couldn't get replay \"" + key + "\"", err

    # replays:create
    _create: (req) =>
        fields =
            title: req.data.title,
            description: req.data.description,
            file: req.data.file.substr 13

        rules =
            title: [@rules.between 3, 30],
            description: [@rules.between 3, 255],
            file: [
                @rules.empty "File must not be empty"
                @rules.size64 300 * 1024, "File size must not exceed 300kb"
            ]

        errors = @rules.validate fields, rules

        if errors? then req.io.emit "replays:created", {err: "Invalid inputs"}
        else
            key = @shortid.generate()
            fields.path = "tmp/uploads/" + key

            buffer = new Buffer fields.file, "base64"

            @fs.writeFileAsync fields.path, buffer
            .then () =>
                return @replays.save key, fields
            .then () =>
                @logger.debug "Replay saved"
                req.io.emit "replays:created", {id: key}
            .catch (err) =>
                @logger.error "Couldn't save replay:", err
                req.io.emit "replays:created", {err: err.toString()}

        ###
        # Replay parameters (Get data from the request)
        params =
            title: req.body.title,
            description: req.body.description,
            path: req.file.path,
            name: req.file.filename

        await replays.save key, params, defer err
        ###
