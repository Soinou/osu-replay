fs = require "fs-extra"
{make_esc} = require "iced-error"
process = require "process"
s3 = require "s3"

class S3Storage
    constructor: (@logger_) ->
        @bucket_ = process.env.S3_BUCKET;
        @region_ = process.env.S3_REGION;
        options =
            s3Options:
                accessKeyId: process.env.S3_ID,
                secretAccessKey: process.env.S3_SECRET,
                region: this.region_,
                endpoint: process.env.S3_ENDPOINT
        @client_ = s3.createClient options
        @logger_.debug "Amazon S3 Storage service successfully initialized"

    upload: (file_path, file_name, callback) ->
        esc = make_esc callback
        params =
            localFile: file_path,
            s3Params:
                Bucket: this.bucket_,
                Key: file_name,
                ACL: "public-read"
        uploader = @client_.uploadFile params
        uploader.on "error", callback
        uploader.on "end", () =>
            @logger_.debug "Replay file uploaded, now deleting it"
            fs.remove file_path, callback
            @logger_.debug "Replay file deleted"

    link: (key) ->
        return s3.getPublicUrlHttp @bucket_, key + ".osr"

class LocalStorage
    constructor: (logger) ->
        logger.debug "Local storage created successfully"

    upload: (file_path, file_name, callback) ->
        esc = make_esc callback
        await fs.move file_path, "public/replays/" + file_name, esc(defer())
        callback null

    link: (key) ->
        return "/replays/" + key + ".osr"

if process.env.NODE_ENV == "production"
    exports = module.exports = S3Storage
else
    exports = module.exports = LocalStorage

exports["@singleton"] = true
exports["@require"] = [ "logger" ]
