React = require "react"

module.exports = class OsuModIcon extends React.Component

    imgProps: ->
        src: "/img/mods/" + @props.mod.id + ".png",
        height: "30px",
        "data-toggle": "tooltip",
        "data-placement": "top",
        title: @props.mod.name

    render: ->
        <img {...@imgProps()} />
