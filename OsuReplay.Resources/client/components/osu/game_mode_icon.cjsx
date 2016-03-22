React = require "react"

module.exports = class OsuGameModeIcon extends React.Component

    render: ->
        <i className={@props.replay.get_game_mode_icon()} />
