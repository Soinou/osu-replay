# Setup relative paths
require("app-module-path").addPath("src/server")

# Setup dotenv
require("dotenv").config()

# Get the kernel
kernel = require "core/kernel"

# Libraries
kernel.library "body_parser", "body-parser"
kernel.library "chalk"
kernel.library "exceptions", "express-exceptions"
kernel.library "express", "express.io"
kernel.library "express_validator", "express-validator"
kernel.library "fs", "fs-extra-promise"
kernel.library "http"
kernel.library "https"
kernel.library "irc_lib", "irc"
kernel.library "leb"
kernel.library "memwatch", "memwatch-next"
kernel.library "moment"
kernel.library "mongojs"
kernel.library "morgan"
kernel.library "numeral"
kernel.library "os"
kernel.library "path"
kernel.library "Promise", "promise"
kernel.library "s3"
kernel.library "session", "express-session"
kernel.library "shortid"
kernel.library "socket_io", "socket.io"
kernel.library "util"
kernel.library "validator"

# Factories
kernel.factory "BufferReader", "utils/buffer_reader", true
kernel.factory "Deque", "collections/deque", true
kernel.factory "Dict", "collections/dict", true
kernel.factory "FastMap", "collections/fast-map", true
kernel.factory "Int64", "node-int64", true
kernel.factory "store", "core/store", true

# Services
kernel.service "api", "osu/api"
kernel.service "application", "core/application"
kernel.service "beatmaps", "stores/beatmaps"
kernel.service "config", "core/config"
kernel.service "HomeController", "controllers/home"
kernel.service "irc", "utils/irc"
kernel.service "logger", "core/logger"
kernel.service "players", "stores/players"
kernel.service "replay", "osu/replay"
kernel.service "replays", "stores/replays"
kernel.service "ReplaysController", "controllers/replays"
kernel.service "rules", "utils/rules"
kernel.service "storage", "core/storage"
kernel.service "UsersController", "controllers/users"

# Resolve the configuration first
config = kernel.resolve "config"

# Then resolve the application
application = kernel.resolve "application"

# And setup the application
process.on "SIGTERM", ->
    application.stop()

application.setup()
application.start()
