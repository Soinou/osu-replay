s3 = require "s3"

# An amazon S3 storage helper
module.exports = class LogHelper

	constructor: (@application) ->

        @_bucket = process.env.S3_BUCKET
        @_region = process.env.S3_REGION

        @_client = s3.createClient
            s3Options:
                accessKeyId: process.env.S3_ID,
                secretAccessKey: process.env.S3_SECRET,
                region: @_region,
                endpoint: process.env.S3_ENDPOINT

        @application.upload = @_upload
        @application.link = @_link

    _upload: (path, key, callback) =>
        params =
            localFile: path,
            s3Params:
                Bucket: @_bucket,
                Key: key,
                ACL: "public-read"

        uploader = @_client.uploadFile params

        uploader.on "error", (err) =>
            @application.error "Could not upload file to S3: " + err
            callback err

        uploader.on "end", -> callback null

    _link: (key) =>
        return s3.getPublicUrlHttp(@_bucket, key)
