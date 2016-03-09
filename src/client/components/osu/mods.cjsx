React = require "react"

ModIcon = require "components/osu/mod_icon.cjsx"

module.exports = class OsuMods extends React.Component

    componentDidMount: ->
        $ () -> $("[data-toggle='tooltip']").tooltip()

    mods: ->
        mods = @props.replay.get_mods()
        if mods.length is 0 then <span>None</span>
        else mods.map (mod, index) -> <ModIcon key={index} mod={mod} />

    render: ->
        <span>{@mods()}</span>
