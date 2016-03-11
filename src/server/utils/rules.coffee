module.exports = class Rules

    dependencies: -> ["validator"]

    check: (rule, message, value, options) ->
        result = rule value.toString(), options
        if not result then message else null

    validate: (fields, rules) ->
        errors = null
        for key in fields
            if fields.hasOwnProperty key
                field = fields[key]
                for rule in rules[key]
                    errors = errors or {}
                    errors[key] = rule field
        return errors

    empty: (message) ->
        (value) ->
            if not value? or not value then return message
            else return null

    email: (message) ->
        (value) => @check @validator.isEmail, message, value, {}

    between: (min, max, message) ->
        (value) => @check @validator.isLength, message, value, {min: min, max: max}

    size64: (max, message) ->
        (value) ->
            if ((value.length * 3) / 4) > max then return message
            else return null

    size: (max, message) ->
        (value) ->
            if value.size > max then return message
            else return null

    extension: (extension, message) ->
        (value) ->
            if not value.name.endsWith extension then return message
            else return null
