React = require "react"

module.exports = class BootstrapAlert extends React.Component

    alertProps: ->
        type = @props.type or "danger"

        return {
            className: "alert alert-" + type
            role: "alert"
        }

    render: ->
        <div {...@alertProps()}>
            <p>{@props.children}</p>
        </div>
