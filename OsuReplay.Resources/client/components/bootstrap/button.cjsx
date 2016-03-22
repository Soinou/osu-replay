React = require "react"

module.exports = class BootstrapButton extends React.Component

    buttonProps: ->
        props = {}

        props.className = "btn btn-" + (@props.type or "primary")

        if @props.submit? then props.type = "submit"

        return props

    render: ->
        <button {...@buttonProps()}>{@props.children}</button>
