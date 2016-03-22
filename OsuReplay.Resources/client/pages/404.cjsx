React = require "react"

module.exports = class NotFound extends React.Component

    render: ->
        <div className="jumbotron">
            <h2>Whoops!</h2>
            <p>Sorry, the page you requested doesn't exist</p>
        </div>
