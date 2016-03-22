React = require "react"

Link = require "components/bootstrap/link.cjsx"

module.exports = class OsuProfileLink extends React.Component

    render: ->
        <Link to={@props.replay.get_player_link()}>
            {@props.replay.player.username}
        </Link>
