React = require "react"

Alert = require "components/bootstrap/alert.cjsx"
Button = require "components/bootstrap/button.cjsx"
Control = require "components/control.cjsx"
Rules = require "utils/rules.coffee"
WaitIcon = require "components/wait_icon.cjsx"

module.exports = class Create extends React.Component

    @contextTypes: {router: React.PropTypes.object}

    constructor: ->
        @socket_ = io.connect()

        @state = waiting: false

        @socket_.on "replays:created", @onSavedReplay

    formProps: ->
        className: if @state.waiting then "hidden" else "",
        onSubmit: @onSubmit

    titleProps: ->
        ref: "title",
        type: "text",
        label: "Title"
        rules: [
            Rules.between(3, 30, "Title must be 3-30 characters")
        ]

    descriptionProps: ->
        ref: "description",
        type: "textarea",
        label: "Description",
        rules: [
            Rules.between(3, 255, "Description must be 3-255 characters")
        ]

    fileProps: ->
        ref: "file",
        type: "file",
        label: "File",
        accept: ".osr",
        rules: [
            Rules.empty("File must not be empty"),
            Rules.extension(".osr", "File must have .osr extension"),
            Rules.size(300 * 1024, "File size must not exceed 300kb")
        ]

    intro: ->
        <div className="jumbotron">
            <h1>Welcome to osu!Replay</h1>
            <p>This website allows you to host for free your osu! replays and share them to the whole world thanks to a single link!</p>
            <p>Choose a title, a description and select your replay file. Upon clicking the upload button, you will be redirected to a page containing all the previously entered informations you have indicated.</p>
            <p>You can then publish the link to whoever you want.</p>
        </div>

    error: -> if @state.error then <Alert>{@state.error}</Alert>

    icon: -> if @state.waiting then <WaitIcon message="Please wait..." />

    form: ->
        <div className="jumbotron">
            {@error()}
            {@icon()}
            <form {...@formProps()}>
                <Control {...@titleProps()} />
                <Control {...@descriptionProps()} />
                <Control {...@fileProps()} />
                <Button type="primary" submit>Upload</Button>
            </form>
        </div>

    render:->
        <div>
            {@intro()}
            {@form()}
        </div>

    onSubmit: (event) =>
        event.preventDefault()

        @setState {waiting: true}

        replay = {
            title: "",
            description: "",
            file: ""
        }

        errors = []

        reader = new FileReader

        reader.onload = (upload) =>
            replay.file = upload.target.result
            @socket_.emit "replays:create", replay

        onFile = (value, error) =>
            if error then errors.push error
            if errors.length > 0 then return
            reader.readAsDataURL value

        onDescription = (value, error) =>
            if error then errors.push error
            replay.description = value
            @refs.file.validate onFile

        onTitle = (value, error) =>
            if error then errors.push error
            replay.title = value
            @refs.description.validate onDescription

        @refs.title.validate onTitle

    onSavedReplay: (data) =>
        if data.err? then @setState {waiting: false, error: data.err}
        else @context.router.push "/replays/" + data.id
