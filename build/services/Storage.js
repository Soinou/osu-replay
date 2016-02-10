var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import * as fs from "fs";
import * as s3 from "s3";
import { Inject } from "inversify";
/**
 * A storage implementation using Amazon S3
 */
export let S3Storage = class {
    /**
     * Creates a new S3Storage
     *
     * @param logger_ Logger service
     */
    constructor(logger_) {
        this.logger_ = logger_;
        /**
         * Amazon S3 bucket name
         */
        this.bucket_ = process.env.S3_BUCKET;
        /**
         * Amazon S3 region
         */
        this.region_ = process.env.S3_REGION;
        var options = {
            s3Options: {
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
     * @param file_path Path of the file on the disk
     * @param key Name of the file in the S3 Bucket
     * @param callback Callback
     */
    upload(file_path, name, callback) {
        var params = {
            localFile: file_path,
            s3Params: {
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
        uploader.on("end", function () {
            fs.unlink(file_path, (err) => {
                callback(err);
            });
        });
    }
    // Returns the link to get the resource identified by the given key
    // on the S3 servers
    link(key) {
        return s3.getPublicUrlHttp(this.bucket_, key);
    }
};
S3Storage = __decorate([
    Inject("ILogger"), 
    __metadata('design:paramtypes', [Object])
], S3Storage);
/**
 * Implementation of the IStorage using local storage
 *
 * (Basically renames the file with the new name)
 */
export let LocalStorage = class {
    /**
     * Creates a new LocalStorage
     *
     * @param logger_ Logger service
     */
    constructor(logger_) {
        this.logger_ = logger_;
        fs.readdirSync("public/uploads").forEach(element => {
            fs.unlinkSync("public/uploads/" + element);
        });
        this.logger_.success("Local storage created successfully");
    }
    /**
     * @inheritdoc
     */
    upload(file_path, name, callback) {
        callback();
    }
    /**
     * @inheritdoc
     */
    link(name) {
        return "/uploads/" + name + ".osr";
    }
};
LocalStorage = __decorate([
    Inject("ILogger"), 
    __metadata('design:paramtypes', [Object])
], LocalStorage);
//# sourceMappingURL=Storage.js.map