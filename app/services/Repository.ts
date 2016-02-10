import * as mongojs from "mongojs";
import * as Dict from "collections/dict";
import * as util from "util";

/**
 * Represents a repository backend
 */
interface IRepository {
    /**
     * Find a document in the database
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
 * Implementation of the IRepository inteface using a MongoDB backend
 */
export class MongoRepository implements IRepository {
    /**
     * MongoDB Collection
     */
    protected collection_: any;

    /**
     * Creates a new MongoRepository
     *
     * @param name Collection name to use
     * @param database MongoDatabase to use
     */
    constructor(name: string) {
        var url = util.format("%s:%s@%s:%s/%s",
            process.env.DB_USER,
            process.env.DB_PASSWORD,
            process.env.DB_HOST,
            process.env.DB_PORT,
            process.env.DB_PATH
        );

        this.collection_ = mongojs(url, [name]).collection(name);
    }

    /**
     * @inheritdoc
     */
    find(id: string, callback: (err: any, document: any) => void) {
        this.collection_.findOne({ id: id }, callback);
    }

    /**
     * @inheritdoc
     */
    insert(id: string, document: any, callback: (err: any) => void) {
        this.collection_.insert(document, callback);
    }

    /**
     * @inheritdoc
     */
    update(id: string, document: any, callback: (err: any) => void) {
        this.collection_.update({ id: id }, document, callback);
    }

    /**
     * @inheritdoc
     */
    delete(id: string, callback: (err: any) => void) {
        this.collection_.delete({ id: id }, callback);
    }
}

/**
 * Implementation of the IRepository interface using a memory collection
 */
export class LocalRepository implements IRepository {
    /**
     * Collection the objects are stored to
     */
    protected collection_: any;

    /**
     * Creates a new LocalRepository
     */
    constructor() {
        this.collection_ = new Dict();
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
export default IRepository;
