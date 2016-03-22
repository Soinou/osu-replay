React = require "react"

module.exports = class OsuAvatar extends React.Component

    render: ->
        <img src={@props.replay.get_avatar_link()} height="63px" />
