IoC = require "./bootstrap"

try
    application = IoC.create "application"

    application.setup()

    application.start()
catch error
    console.err "Unexpected error: "
    console.err error.stack
