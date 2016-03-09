React = require "react"

module.exports = class OsuBeatmapLink extends React.Component

    link: -> @props.replay.get_beatmap_link()

    text: ->
        artist = @props.replay.beatmap.artist
        title = @props.replay.beatmap.title
        version = @props.replay.beatmap.version
        return artist + " - " + title + " [" + version + "]"

    render: ->
        <a href={@link()}>{@text()}</a>
