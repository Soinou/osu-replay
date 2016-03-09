React = require "react"

module.exports = class WaitIcon extends React.Component

    render: ->
        <div className="wait-wrapper">
            <p>{@props.message}</p>
            <i className="fa fa-spinner fa-spin wait-icon" />
        </div>
