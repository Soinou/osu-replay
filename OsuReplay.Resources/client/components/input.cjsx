React = require "react"

module.exports = class Input extends React.Component

    # Creates a new Input
    constructor: ->
        @state = {value: "", error: ""}

    # Getters
    getValue: ->
        if @state.value then return @state.value
        else if @props.type is "file" then return @refs.input.files[0] or ""
        else return @refs.input.value or ""

    # Validates the input
    validate: (value, callback) ->
        # Get the given value or the current value
        value = if value? then value else @getValue()

        # Get rules
        rules = @props.rules or []

        # For each rule
        for rule in rules
            # Match it against the value
            error = rule value

            # If the rule doesn't match
            if error then return @setState {value: value, error: error}, ->
                # Send the error back
                callback value, error

        # All the rules passed, send back no error
        @setState {value: value, error: ""}, ->
            callback value, false

    _textAreaProps: ->
        className: "form-control",
        onChange: @onChange,
        ref: "input",
        rows: @props.rows,
        value: @state.value

    _fileProps: ->
        accept: @props.accept,
        className: "form-control",
        filename: @props.filename,
        onChange: @onFileChange,
        ref: "input",
        type: "file"

    # Input properties
    _inputProps: ->
        className: "form-control",
        onChange: @onChange,
        ref: "input",
        type: @props.type,
        value: @state.value

    # Render the input
    render: ->
        switch @props.type
            when "textarea"
                <textarea {...@_textAreaProps()} />
            when "file"
                <input {...@_fileProps()} />
            else
                <input {...@_inputProps()} />

    # Change callback
    onChange: (event) =>
        value = event.target.value or ""
        # Validate the input
        @validate value, (value, error) =>
            # And callback with the new value/error pair
            @props.onChange error

    onFileChange: (event) =>
        value = event.target.files[0] or ""
        # Validate the input
        @validate value, (value, error) =>
            # And callback with the new value/error pair
            @props.onChange error
