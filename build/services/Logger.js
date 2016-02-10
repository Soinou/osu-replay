import * as chalk from "chalk";
import * as fs from "fs";
import * as moment from "moment";
import * as os from "os";
/**
 * ILogger implementation
 */
export class Logger {
    /**
     * Creates a new Logger
     */
    constructor() {
        if (!fs.existsSync(Logger.kDirectory)) {
            fs.mkdirSync(Logger.kDirectory);
        }
    }
    /**
     * Internal logging
     *
     * @param message Message to log
     * @param status Status of the message
     * @param color Color to use for the outputted message
     */
    _log(message, status, color) {
        var timestamp = moment().format("HH:mm:ss");
        console.log(timestamp + " [" + color(status) + "] " + message);
        fs.appendFileSync(Logger.kDirectory + "/" + moment().format("YYYY-MM-DD") + ".log", timestamp + " [" + status + "] " + message + os.EOL);
    }
    /**
     * @inheritdoc
     */
    success(message) {
        this._log(message, "Success", chalk.green);
    }
    /**
     * @inheritdoc
     */
    info(message) {
        this._log(message, "Info", chalk.cyan);
    }
    /**
     * @inheritdoc
     */
    warning(message) {
        this._log(message, "Warning", chalk.yellow);
    }
    /**
     * @inheritdoc
     */
    error(message) {
        this._log(message, "Error", chalk.red);
    }
    /**
     * @inheritdoc
     */
    fatal(message) {
        this._log(message, "Fatal", chalk.blue.bgRed);
        process.exit(0);
    }
}
/**
 * Logs directory
 */
Logger.kDirectory = "bin/logs";
//# sourceMappingURL=Logger.js.map