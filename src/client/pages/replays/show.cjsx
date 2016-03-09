React = require "react"

Alert = require "components/bootstrap/alert.cjsx"
Link = require "components/bootstrap/link.cjsx"
Replay = require "osu/replay.coffee"
ReplayComponent = require "components/osu/replay.cjsx"
WaitIcon = require "components/wait_icon.cjsx"

module.exports = class Show extends React.Component

    constructor: ->
        @state = {waiting: true, replay: null}

    componentDidMount: ->
        @socket_ = io.connect()
        @socket_.on "replays:got", @onReplay
        @socket_.emit "replays:get", @props.params.replayId

    render:->
        if @state.waiting
            <div className="jumbotron">
                <WaitIcon message="Please wait..." />
            </div>
        else if not @state.replay?
            <div className="jumbotron">
                <h2>Whoops!</h2>
                <p>Sorry, the replay you requested doesn't exist</p>
            </div>
        else
            <div>
                <Alert type="warning">
                    Keep a save of your link, because if you lose it, you will not be able to get it back.
                </Alert>
                <ReplayComponent replay={@state.replay} />
                <div className="jumbotron">
                    <center>
                        <Link type="primary" to="/">Upload another replay</Link>
                    </center>
                    <p><b>Don't hesitate to leave a comment!</b></p>
                    <div id="disqus_thread" className="row"></div>
                </div>
            </div>

    onReplay: (replay) =>
        if not replay? then return @setState {waiting: false}

        replay = new Replay replay
        @setState {waiting: false, replay: replay}

        window.disqus_config = () ->
            @page.url = "http://osu-replay.info/replays/" + replay._id
            @page.identifier = replay._id
            @page.title = replay.title

        d = document
        s = d.createElement "script"
        s.src = "//osureplay.disqus.com/embed.js"

        s.setAttribute "data-timestamp", +new Date()
        (d.head || d.body).appendChild s
