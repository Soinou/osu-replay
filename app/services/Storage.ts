import * as fs from "fs";
import * as s3 from "s3";
import { Inject } from "inversify";

import ILogger from "./Logger";

/**
 * Represents a Storage wrapper
 */
export interface IStorage {
    /**
     * Uploads the given file using the given name
     *
     * @param path Path of the file on the disk
     * @param name Name to upload the file with
     * @param callback Function called upon upload completion
     */
    upload(path: string, name: string, callback: (err?: any) => void);

    /**
     * Returns the http link associated with the given name
     *
     * @param name Name to get the link for
     */
    link(name: string);
}

/**
 * A storage implementation using Amazon S3
 */
@Inject("ILogger")
export class S3Storage implements IStorage {
    /**
     * Amazon S3 bucket name
     */
    protected bucket_: string = process.env.S3_BUCKET;

    /**
     * Amazon S3 region
     */
    protected region_: string = process.env.S3_REGION;

    /**
     * Amazon S3 client
     */
    protected client_: any;

    /**
     * Creates a new S3Storage
     *
     * @param logger_ Logger service
     */
    constructor(protected logger_: ILogger) {
        var options =
            {
                s3Options:
                {
                    accessKeyId: process.env.S3_ID,
                    secretAccessKey: process.env.S3_SECRET,
                    region: this.region_,
                    endpoint: process.env.S3_ENDPOINT
                }
            };

        this.client_ = s3.createClient(options);

        this.logger_.success("Storage service successfully initialized");
    }

    /**
     * Uploads the file to Amazon S3
     *
     * @param path Path of the file on the disk
     * @param key Name of the file in the S3 Bucket
     * @param callback Callback
     */
    upload(path: string, name: string, callback: (err?: any) => void) {
        var params =
            {
                localFile: path,
                s3Params:
                {
                    Bucket: this.bucket_,
                    Key: name,
                    ACL: "public-read"
                }
            };

        var uploader = this.client_.uploadFile(params);

        uploader.on("error", (err) => {
            this.logger_.error("Could not upload file to S3: " + err);
            callback(err);
        });

        uploader.on("end", function() {
            fs.unlink(path, (err) => {
                callback(err);
            });
        });
    }

    // Returns the link to get the resource identified by the given key
    // on the S3 servers
    link(key) {
        return s3.getPublicUrlHttp(this.bucket_, key);
    }
}

/**
 * Implementation of the IStorage using local storage
 *
 * (Basically renames the file with the new name)
 */
@Inject("ILogger")
export class LocalStorage implements IStorage {
    /**
     * Creates a new LocalStorage
     *
     * @param logger_ Logger service
     */
    constructor(protected logger_: ILogger) {

    }

    /**
     * @inheritdoc
     */
    upload(path: string, name: string, callback: (err?: any) => void) {
        fs.rename(path, "public/uploads/" + name, callback);
    }

    /**
     * @inheritdoc
     */
    link(name: string) {
        return "/uploads/" + name;
    }
}

// Exports
export default IStorage;
