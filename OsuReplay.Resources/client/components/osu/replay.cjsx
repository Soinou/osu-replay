React = require "react"

BeatmapLink = require "components/osu/beatmap_link.cjsx"
Link = require "components/bootstrap/link.cjsx"
Mods = require "components/osu/mods.cjsx"
Title = require "components/osu/replay_title.cjsx"

module.exports = class OsuReplay extends React.Component

    render: ->
        <div className="jumbotron">
            <Title replay={@props.replay} />
            <div className="row">
                <div className="row">
                    <p><b>Game mode:</b> {@props.replay.get_game_mode()}</p>
                    <p><b>Beatmap:</b> <BeatmapLink replay={@props.replay} /></p>
                    <p><b>Mods:</b> <Mods replay={@props.replay} /></p>
                    <p><b>Score:</b> {@props.replay.get_score()}</p>
                    <p><b>Max combo:</b> {@props.replay.get_combo()}</p>
                    <p><b>Accuracy:</b> {@props.replay.get_accuracy()}%</p>
                </div>
                <div className="row">
                    <div className="well">
                        <p><b>Description:</b> {@props.replay.description}</p>
                    </div>
                    <Link type="success" to={@props.replay.link} block>Download</Link>
                    <h5 className="replay-link-text">Replay {@props.id}</h5>
                </div>
            </div>
        </div>
