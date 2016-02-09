import * as chalk from "chalk";
import * as fs from "fs";
import * as moment from "moment";
import * as os from "os";

// Logger
export default class Logger
{
    constructor()
    {
        if(!fs.existsSync("logs"))
        {
            fs.mkdirSync("logs");
        }
    }

    // Logs the given message to the console and to the log file
    _log(message, status, color)
    {
        var timestamp = moment().format("HH:mm:ss")
        console.log(timestamp + " [" + color(status) + "] " + message)
        fs.appendFileSync("logs/" + moment().format("YYYY-MM-DD") + ".log", timestamp + " [" + status + "] " + message + os.EOL)
    }

    // Logs a success message
    success(message)
    {
        this._log(message, "Success", chalk.green);
    }

    // Logs an info message
    info(message)
    {
        this._log(message, "Info", chalk.cyan);
    }

    // Logs a warning message
    warning(message)
    {
        this._log(message, "Warning", chalk.yellow);
    }

    // Logs an error message
    error(message)
    {
        this._log(message, "Error", chalk.red);
    }

    // Logs a fatal message
    fatal(message)
    {
        this._log(message, "Fatal", chalk.blue.bgRed);
        process.exit(0);
    }
}

// Electrolyte exports
exports = module.exports = Logger;
exports["@singleton"] = true;
