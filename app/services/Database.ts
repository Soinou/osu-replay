import * as mongodb from "mongodb";
import * as Dict from "collections/Dict";
import * as util from "util";

import ILogger from "./Logger";

import { Inject } from "inversify";

/**
 * Represents a database backend
 */
interface IDatabase {
    /**
     * Connects the database
     *
     * @param callback Callback called once the connection is established
     */
    connect(callback: () => void);

    /**
     * Find a document from the database
     *
     * @param id Document ID
     * @param callback Callback called once the document is found
     */
    find(id: string, callback: (err: any, document: any) => void);

    /**
     * Inserts a new document in the database
     *
     * @param id Document ID
     * @param document Document to insert
     * @param callback Callback called once the document is inserted
     */
    insert(id: string, document: any, callback: (err: any) => void);

    /**
     * Updates a document of the database
     *
     * @param id Document ID
     * @param document Document to insert
     * @param callback Callback called once the document is updated
     */
    update(id: string, document: any, callback: (err: any) => void);

    /**
     * Deletes a document of the database
     *
     * @param id Document ID
     * @param callback Callback called once the document is deleted
     */
    delete(id: string, callback: (err: any) => void);
}

/**
 * Implementation of the IDatabase inteface using a MongoDB backend
 */
@Inject("ILogger")
export class MongoDBDatabase implements IDatabase {
    /**
     * MongoDB Database
     */
    protected database_: any;

    /**
     * MongoDB Collection
     */
    protected collection_: any;

    /**
     * Creates a new MongoDBDatabase
     */
    constructor(protected logger_: ILogger) {
        this.database_ = null;
        this.collection_ = null;
        this.logger_.success("MongoDB database created successfully");
    }

    /**
     * @inheritdoc
     */
    connect(callback: () => void) {
        var url = util.format("mongodb://%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH
        );

        mongodb.connect(url, (err: any, database: any) => {
            if (err) {
                this.logger_.fatal("Could not connect to the MongoDB database: " + err);
            }
            else {
                this.logger_.success("Connection to the MongoDB database established successfully");
                this.database_ = database;
                this.collection_ = database.collection(name);
                callback();
            }
        });
    }

    /**
     * @inheritdoc
     */
    find(id: string, callback: (err: any, document: any) => void) {
        if (!this.collection_) {
            callback("MongoDB collection is not initialized yet", null);
        }
        else {
            this.collection_.find({ id: id }).limit(1).forEach((document: any) => {
                callback(null, document);
            }, (err: any) => {
                callback(err, null);
            });
        }
    }

    /**
     * @inheritdoc
     */
    insert(id: string, document: any, callback: (err: any) => void) {
        if (!this.collection_) {
            callback("MongoDB collection is not initialized yet");
        }
        else {
            this.collection_.insertOne(document, callback);
        }
    }

    /**
     * @inheritdoc
     */
    update(id: string, document: any, callback: (err: any) => void) {
        if (!this.collection_) {
            callback("MongoDB collection is not initialized yet");
        }
        else {
            this.collection_.updateOne({ id: id }, document, callback);
        }
    }

    /**
     * @inheritdoc
     */
    delete(id: string, callback: (err: any) => void) {
        if (!this.collection_) {
            callback("MongoDB collection is not initialized yet");
        }
        else {
            this.collection_.deleteOne({ id: id }, callback);
        }
    }
}

/**
 * Implementation of the IDatabase interface using a memory collection
 */
@Inject("ILogger")
export class LocalDatabase implements IDatabase {
    /**
     * Collection the objects are stored to
     */
    protected collection_: any;

    /**
     * Creates a new LocalDatabase
     */
    constructor(protected logger_: ILogger) {
        this.collection_ = new Dict();
        this.logger_.success("Local database created successfully");
    }

    /**
     * @inheritdoc
     */
    connect(callback: () => void) {
        this.logger_.success("Local database connected successfully");
        callback();
    }

    /**
     * @inheritdoc
     */
    find(id: string, callback: (err: any, record: any) => void) {
        callback(null, this.collection_.get(id, null));
    }

    /**
     * @inheritdoc
     */
    insert(id: string, record: any, callback: (err: any) => void) {
        this.collection_.set(id, record);
        callback(null);
    }

    /**
     * @inheritdoc
     */
    update(id: string, record: any, callback: (err: any) => void) {
        this.collection_.set(id, record);
        callback(null);
    }

    /**
     * @inheritdoc
     */
    delete(id: string, callback: (err: any) => void) {
        this.collection_.delete(id);
        callback(null);
    }
}

/**
 * Exports
 */
export default IDatabase;
