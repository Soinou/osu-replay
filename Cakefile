IoC = require "./app/bootstrap"

add_task = (command_string, description) ->
    task command_string, description, (options) ->
        command = IoC.create command_string
        command.run options

add_task "migrate", "Runs the pending migrations"
add_task "start", "Starts the server"
add_task "hello", "Prints Hello World!"
add_task "test", "Runs the mocha tests"
