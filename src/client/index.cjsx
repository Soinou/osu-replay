React = require "react"
{render} = require "react-dom"
{Link, Redirect, Route, Router, browserHistory} = require "react-router"

Create = require "pages/replays/create.cjsx"
Show = require "pages/replays/show.cjsx"
NotFound = require "pages/404.cjsx"

class Body extends React.Component

    render: ->
        <Router history={browserHistory}>
            <Route path="/" component={Create} />
            <Route path="/replays/:replayId" component={Show} />
            <Route path="*" component={NotFound} />
        </Router>

render <Body />, document.getElementById "content"
