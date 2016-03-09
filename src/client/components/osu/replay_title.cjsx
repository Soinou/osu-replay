React = require "react"

GameModeIcon = require "components/osu/game_mode_icon.cjsx"
ProfileLink = require "components/osu/profile_link.cjsx"
Avatar = require "components/osu/avatar.cjsx"

module.exports = class OsuReplayTitle extends React.Component

    render: ->
        replay = @props.replay
        title = replay.title
        <h1>
            <GameModeIcon replay={replay} /> {title}, <small>by <ProfileLink replay={replay} /></small> <Avatar replay={replay} />
        </h1>
