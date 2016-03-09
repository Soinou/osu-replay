validator = require "validator"

class Rules

    check: (rule, message, value, options) ->
        result = rule value.toString(), options
        if not result then message else false

    empty: (message) ->
        (value) ->
            if not value? or not value then return message
            else return false

    email: (message) ->
        (value) => @check validator.isEmail, message, value, {}

    between: (min, max, message) ->
        (value) => @check validator.isLength, message, value, {min: min, max: max}

    size: (max, message) ->
        (value) =>
            if value.size > max then return message
            else return false

    extension: (extension, message) ->
        (value) =>
            if not value.name.endsWith extension then return message
            else return false

module.exports = new Rules
