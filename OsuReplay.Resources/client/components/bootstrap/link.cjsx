React = require "react"

module.exports = class BootstrapLink extends React.Component

    linkProps: ->
        props = {}

        props.href = @props.to

        type = @props.type or "normal"

        if type is "normal" then props.className = ""
        else props.className = "btn btn-" + type

        if @props.block? then props.className += " btn-block"

        return props

    render: ->
        <a {...@linkProps()}>{@props.children}</a>
