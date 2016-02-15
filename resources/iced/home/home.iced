exports = module.exports = class Home

    constructor: ->
        @has_errors_ = false

    install: ->
        $("#replay_title").on "change", ->

        $("#replay_description").on "change", ->

        $("#replay_file").on "change", ->
            if @files.length isnt 1 then return

            if @files[0].size > (300 * 1024)
                $("#replay_file_control").addClass "has-error"
                $("#replay_file_help").html "File is too big!"
                @value = ""
            else
                $("#replay_file_control").removeClass "has-error"
                $("#replay_file_help").html ""

        $("#replay").on "submit", (event) ->
            # if(has_errors)
            event.preventDefault()
