import * as chalk from "chalk";
import * as fs from "fs";
import * as moment from "moment";
import * as os from "os";

/**
 * Represents a logger service
 */
interface ILogger {
    /**
     * Logs a success message
     *
     * @param message Message to log
     */
    success(message: string);

    /**
     * Logs an info message
     *
     * @param message Message to log
     */
    info(message: string);

    /**
     * Logs a warning message
     *
     * @param message Message to log
     */
    warning(message: string);

    /**
     * Logs an error message
     *
     * @param message Message to log
     */
    error(message: string);

    /**
     * Logs a success message
     *
     * @param message Message to log
     */
    fatal(message: string);
}

/**
 * ILogger implementation
 */
export class Logger implements ILogger {
    /**
     * Logs directory
     */
    protected static kDirectory: string = "bin/logs";

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
    protected _log(message: string, status: string, color: any) {
        var timestamp = moment().format("HH:mm:ss")
        console.log(timestamp + " [" + color(status) + "] " + message)
        fs.appendFileSync(Logger.kDirectory + "/" + moment().format("YYYY-MM-DD") + ".log", timestamp + " [" + status + "] " + message + os.EOL)
    }

    /**
     * @inheritdoc
     */
    success(message: string) {
        this._log(message, "Success", chalk.green);
    }

    /**
     * @inheritdoc
     */
    info(message: string) {
        this._log(message, "Info", chalk.cyan);
    }

    /**
     * @inheritdoc
     */
    warning(message: string) {
        this._log(message, "Warning", chalk.yellow);
    }

    /**
     * @inheritdoc
     */
    error(message: string) {
        this._log(message, "Error", chalk.red);
    }

    /**
     * @inheritdoc
     */
    fatal(message: string) {
        this._log(message, "Fatal", chalk.blue.bgRed);
        process.exit(0);
    }
}

/**
 * Exports
 */
export default ILogger;
