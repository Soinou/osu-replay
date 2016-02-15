{make_esc} = require "iced-error"
moment = require "moment"

exports = module.exports = class AddTimestamp

    constructor: ->

    run: (logger, beatmaps, replays, users, callback) ->
        esc = make_esc callback
        logger.info "Adding timestamps"
        now = moment().format()
        logger.info "Setting timestamp: " + now
        await replays.all esc(defer(documents))
        for doc in documents
            logger.info "Updating replay " + doc._id
            doc.created_at = now
            doc.updated_at = now
            await replays.update doc._id, doc, esc(defer())
        callback null
