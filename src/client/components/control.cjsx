React = require "react"

Input = require "components/input.cjsx"

module.exports = class Control extends React.Component

    constructor: ->
        @state = {error: null}

    validate: (callback) ->
        @refs.input.validate null, (value, error) =>
            @setState {error: error}, ->
                callback value, error

    _inputProps: ->
        ref: "input",
        accept: @props.accept,
        filename: @props.filename,
        onChange: @onChange,
        rows: @props.rows,
        rules: @props.rules,
        type: @props.type

    render: ->
        controlClass = "form-group"

        error = @state.error

        if error?
            if error
                controlClass += " has-error"
            else
                controlClass += " has-success"

        <div className={controlClass}>
            <label className="control-label">{@props.label}</label>
            <Input {...@_inputProps()} />
            <span className="help-block">{@state.error or ""}</span>
        </div>

    onChange: (error) =>
        @setState {error: error}
