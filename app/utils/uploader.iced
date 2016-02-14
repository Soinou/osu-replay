fs = require "fs-extra"
multer = require "multer"
path = require "path"
shortid = require "shortid"

# Change shortid characters (Replace _ and - with $ and +)
shortid.characters "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$+"

exports = module.exports = class Uploader

    constructor: (@logger_) ->
        fs.ensureDirSync "tmp/uploads"

        storage = multer.diskStorage {
            destination: @destination,
            filename: @filename
        }

        @uploader_ = multer {storage: storage, fileFilter: @filter}

    single: (name) ->
        return @uploader_.single name

    destination: (req, file, callback) =>
        callback null, "tmp/uploads"

    filename: (req, file, callback) =>
        id = shortid.generate()
        file.id = id
        callback null, id + ".osr"

    filter: (req, file, callback) =>
        if path.extname file.originalname is not ".osr"
            callback null, false
        else if file.encoding is not "7bit"
            callback null, false
        else if file.mimetype is not "application/octet-stream"
            callback null, false
        else
            callback null, true

exports["@singleton"] = true
exports["@require"] = [ "logger" ]
