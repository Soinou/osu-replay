dotenv = require "dotenv"
fs = require "fs-extra"
IoC = require "electrolyte"
process = require "process"

if not fs.existsSync ".env"
    fs.copySync ".env.example", ".env"
    if process.env.NODE_ENV != "production"
        logger.fatal "Please setup the .env file"

dotenv.config()

IoC.use IoC.node "app/commands"
IoC.use IoC.node "app/controllers"
IoC.use IoC.node "app/core"
IoC.use IoC.node "app/osu"
IoC.use IoC.node "app/stores"
IoC.use IoC.node "app/utils"
IoC.use IoC.node "migrations"

exports = module.exports = IoC
