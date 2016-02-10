var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import * as mongodb from "mongodb";
import * as Dict from "collections/Dict";
import * as util from "util";
import { Inject } from "inversify";
/**
 * Implementation of the IDatabase inteface using a MongoDB backend
 */
export let MongoDBDatabase = class {
    /**
     * Creates a new MongoDBDatabase
     */
    constructor(logger_) {
        this.logger_ = logger_;
        this.database_ = null;
        this.collection_ = null;
        this.logger_.success("MongoDB database created successfully");
    }
    /**
     * @inheritdoc
     */
    connect(callback) {
        var url = util.format("mongodb://%s:%s@%s:%s/%s", process.env.DB_USER, process.env.DB_PASSWORD, process.env.DB_HOST, process.env.DB_PORT, process.env.DB_PATH);
        mongodb.connect(url, (err, database) => {
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
    find(id, callback) {
        if (!this.collection_) {
            callback("MongoDB collection is not initialized yet", null);
        }
        else {
            this.collection_.find({ id: id }).limit(1).forEach((document) => {
                callback(null, document);
            }, (err) => {
                callback(err, null);
            });
        }
    }
    /**
     * @inheritdoc
     */
    insert(id, document, callback) {
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
    update(id, document, callback) {
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
    delete(id, callback) {
        if (!this.collection_) {
            callback("MongoDB collection is not initialized yet");
        }
        else {
            this.collection_.deleteOne({ id: id }, callback);
        }
    }
};
MongoDBDatabase = __decorate([
    Inject("ILogger"), 
    __metadata('design:paramtypes', [Object])
], MongoDBDatabase);
/**
 * Implementation of the IDatabase interface using a memory collection
 */
export let LocalDatabase = class {
    /**
     * Creates a new LocalDatabase
     */
    constructor(logger_) {
        this.logger_ = logger_;
        this.collection_ = new Dict();
        this.logger_.success("Local database created successfully");
    }
    /**
     * @inheritdoc
     */
    connect(callback) {
        this.logger_.success("Local database connected successfully");
        callback();
    }
    /**
     * @inheritdoc
     */
    find(id, callback) {
        callback(null, this.collection_.get(id, null));
    }
    /**
     * @inheritdoc
     */
    insert(id, record, callback) {
        this.collection_.set(id, record);
        callback(null);
    }
    /**
     * @inheritdoc
     */
    update(id, record, callback) {
        this.collection_.set(id, record);
        callback(null);
    }
    /**
     * @inheritdoc
     */
    delete(id, callback) {
        this.collection_.delete(id);
        callback(null);
    }
};
LocalDatabase = __decorate([
    Inject("ILogger"), 
    __metadata('design:paramtypes', [Object])
], LocalDatabase);
//# sourceMappingURL=Database.js.map