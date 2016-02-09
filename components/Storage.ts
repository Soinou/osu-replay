import * as s3 from "s3";
import Logger from "./Logger";

// An amazon S3 storage helper
export default class Storage
{
    // S3 Bucket
    protected _bucket: string = process.env.S3_BUCKET;

    // S3 Region
    protected _region: string = process.env.S3_REGION;

    // S3 Client
    protected _client: any;

    // Creates a new Storage helper
	constructor(protected _logger: Logger)
    {
        var options =
        {
            s3Options:
            {
                accessKeyId: process.env.S3_ID,
                secretAccessKey: process.env.S3_SECRET,
                region: this._region,
                endpoint: process.env.S3_ENDPOINT
            }
        };

        this._client = s3.createClient(options);

        this._logger.info("Storage service successfully initialized");
    }

    // Uploads the file at the given path to the S3 bucket with the given key
    upload(path, key, callback)
    {
        var params =
        {
            localFile: path,
            s3Params:
            {
                Bucket: this._bucket,
                Key: key,
                ACL: "public-read"
            }
        };

        var uploader = this._client.uploadFile(params);

        uploader.on("error", (err) =>
        {
            this._logger.error("Could not upload file to S3: " + err);
            callback(err);
        });

        uploader.on("end", function()
        {
            callback(null);
        });
    }

    // Returns the link to get the resource identified by the given key
    // on the S3 servers
    link(key)
    {
        return s3.getPublicUrlHttp(this._bucket, key);
    }
}

// Electrolyte exports
exports = module.exports = Storage;
exports["@singleton"] = true;
exports["@require"] = [ "Logger" ];
