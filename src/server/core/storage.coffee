class S3Storage
    dependencies: -> [
        "fs",
        "logger",
        "Promise",
        "s3"
    ]

    initialized: ->
        @bucket_ = process.env.S3_BUCKET
        @region_ = process.env.S3_REGION
        options =
            s3Options:
                accessKeyId: process.env.S3_ID,
                secretAccessKey: process.env.S3_SECRET,
                region: this.region_,
                endpoint: process.env.S3_ENDPOINT
        @client_ = @s3.createClient options
        @logger.debug "S3Storage created successfully"

    upload: (file_path, file_name, callback) ->
        params =
            localFile: file_path,
            s3Params:
                Bucket: @bucket_,
                Key: file_name + ".osr",
                ACL: "public-read"

        @logger.debug "Uploading file to S3 storage"

        return new @Promise (resolve, reject) =>
            uploader = @client_.uploadFile params
            uploader.on "error", reject
            uploader.on "end", resolve
        .then () =>
            @logger.debug "File uploaded to S3 storage"
            return @fs.removeAsync file_path

    link: (key) -> @s3.getPublicUrlHttp @bucket_, key + ".osr"

class LocalStorage
    dependencies: -> [
        "fs",
        "logger",
        "Promise"
    ]

    initialized: ->
        @fs.ensureDirSync "public/replays"
        @logger.debug "LocalStorage created successfully"

    upload: (file_path, file_name) ->
        @logger.debug "Moving file to replays directory"
        path = "public/replays/" + file_name + ".osr"
        return @fs.moveAsync file_path, path
        .then () => @logger.debug "File moved to replays directory"

    link: (key) -> "/replays/" + key + ".osr"

if process.env.NODE_ENV is "production"
    module.exports = S3Storage
else
    module.exports = LocalStorage
