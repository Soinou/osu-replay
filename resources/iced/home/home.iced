Input = require "./input.iced"

exports = module.exports = class Home

    constructor: ->
        @title_ = null
        @description_ = null
        @file_ = null

    validate_title: (input) ->
        value = input.val()

        if not value? or value is ""
            return "Title must not be empty"
        else if value.length < 3 or value.length > 30
            return "Title must be 3-30 characters long"
        else return ""

    validate_description: (input) ->
        value = input.val()

        if not value or value is ""
            return "Description must not be empty"
        else if value.length < 3 or value.length > 255
            return "Description must be 3-255 characters long"
        else
            return ""

    validate_file: (input) ->
        files = input.prop "files"

        if files.length isnt 1
            return "File must not be empty"
        else if files[0].size > (300 * 1024)
            $("#replay_file").val ""
            return "File is too big!"
        else
            return ""

    is_valid: ->
        return @title_.is_valid() and @description_.is_valid() and @file_.is_valid()

    install: ->
        @title_ = new Input "replay_title", @validate_title
        @description_ = new Input "replay_description", @validate_description
        @file_ = new Input "replay_file", @validate_file

        $("#replay").on "submit", (event) =>
            if not @is_valid()
                event.preventDefault()
