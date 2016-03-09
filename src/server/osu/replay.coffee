# Factory to create replays
module.exports = class Replay

    dependencies: -> [
        "beatmaps",
        "BufferReader",
        "fs",
        "logger",
        "players",
        "Promise",
        "storage"
    ]

    # Creates a new Replay based on data taken from the database
    from_data: (data) ->
        @logger.debug "Populating replay from store data, getting beatmap"
        return @beatmaps.get data.beatmap, data.mode
        .then (beatmap) =>
            @logger.debug "Got beatmap, getting player"
            data.beatmap = beatmap
            return @players.get data.player, data.mode
        .then (player) =>
            @logger.debug "Got player, returning replay"
            data.player = player
            data.link = @storage.link data._id
            return @Promise.resolve data

    # Creates a new Replay based on a file buffer
    from_file: (path) ->
        @logger.debug "Reading file \"" + path + "\""
        return @fs.readFileAsync path
        .then (data) =>
            @logger.debug "File \"" + path + "\" successfully read, parsing replay"
            reader = @BufferReader.create data
            replay = {}
            replay.mode = reader.read_byte()
            replay.version = reader.read_int()
            replay.beatmap = reader.read_string()
            replay.player = reader.read_string()
            replay.hash = reader.read_string()
            replay.n_300 = reader.read_short()
            replay.n_100 = reader.read_short()
            replay.n_50 = reader.read_short()
            replay.gekis = reader.read_short()
            replay.katus = reader.read_short()
            replay.misses = reader.read_short()
            replay.score = reader.read_int()
            replay.combo = reader.read_short()
            replay.perfect = reader.read_byte()
            replay.mods = reader.read_int()
            reader.read_string() # Replay life bar graph, useless
            replay.timestamp = reader.read_long()
            @logger.debug "Replay successfully parsed"
            return @Promise.resolve replay
