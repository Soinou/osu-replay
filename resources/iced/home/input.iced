exports = module.exports = class Input

    constructor: (id, check) ->
        @check_ = check
        @input_ = $("#" + id)
        @input_control_ = $("#" + id + "_control")
        @input_help_ = $("#" + id + "_help")
        @error_ = false
        @input_.on "change paste keyup", @_update

    is_valid: ->
        @_update()
        return not @error_

    _update: =>
        @error_ = @check_ @input_

        if @error_? and @error_ isnt ""
            @input_control_.addClass "has-error"
            @input_control_.removeClass "has-success"
            @input_help_.html @error_
        else
            @input_control_.addClass "has-success"
            @input_control_.removeClass "has-error"
            @input_help_.html ""

        return true
