IoC = require "./bootstrap"

application = IoC.create "application"

application.setup()

application.start()
