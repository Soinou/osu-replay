fs = require "fs-extra"
{make_esc} = require "iced-error"
path = require "path"
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

    upload: (file_path, name, callback) ->
        esc = make_esc callback
        @logger_.debug "Renaming replay from \"" + file_path + "\" to \"" + file_path + ".osr\""
        await fs.rename file_path, file_path + ".osr", esc(defer())
        @logger_.debug "Replay file renamed, now uploading it"
        params =
            localFile: file_path + ".osr",
            s3Params:
                Bucket: this.bucket_,
                Key: name + ".osr",
                ACL: "public-read"
        uploader = @client_.uploadFile params
        uploader.on "error", callback
        uploader.on "end", () =>
            @logger_.debug "Replay file uploaded, now deleting it"
            fs.unlink file_path + ".osr", callback
            @logger_.debug "Replay file deleted"

    link: (key) ->
        return s3.getPublicUrlHttp @bucket_, key + ".osr"

class LocalStorage
    constructor: (logger) ->
        logger.debug "Local storage created successfully"

    upload: (file_path, name, callback) ->
        callback null

    link: (name) ->
        return "/uploads/" + name

if process.env.NODE_ENV == "production"
    exports = module.exports = S3Storage
else
    exports = module.exports = LocalStorage

exports["@singleton"] = true
exports["@require"] = [ "logger" ]
