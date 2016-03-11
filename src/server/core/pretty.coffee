PrettyError = require "pretty-error"

class Pretty

    constructor: ->
        # Packages to ignore in the pretty error renderer
        packages = [
            "body-parser",
            "coffee-script",
            "express",
            "express-session",
            "express-validator",
            "morgan",
            "send",
            "socket.io"
        ]

        # Pretty error renderer setup
        @pretty_ = new PrettyError
        @pretty_.skipPackage packages...
        @pretty_.skipNodeFiles()
        @pretty_.appendStyle @style()

    render: (err) -> @pretty_.render err

    style: ->
        "pretty-error":
            marginLeft: "1"

        "pretty-error > header > title > kind":
            color: "red",
            background: "black"

        "pretty-error > header > colon":
            color: "red"

        "pretty-error > trace > item":
            bullet: "'<red>o</red>'"

        "pretty-error > trace > item > header > pointer > file":
            color: "cyan"

        "pretty-error > trace > item > header > pointer > colon":
            color: "cyan"

        "pretty-error > trace > item > header > pointer > line":
            color: "cyan"

        "pretty-error > trace > item > header > what":
            color: "bright-white"

        "pretty-error > trace > item > footer > addr":
            display: "none"

module.exports = new Pretty
