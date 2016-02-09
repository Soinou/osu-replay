import { Document, Model, model, Schema } from "mongoose";

/**
 * Represents an application Model
 */
interface IModel {
    /**
     * Creates a new document based off this model
     *
     * @param params Parameters to pass to the document
     */
    create(params: any): Document

    /**
     * Finds a record matching the given parameters
     *
     * @param params Parameters
     * @param callback Callback called once the search is done
     */
    findOne(params: any, callback: (err: any, record: Document) => void);
}

/**
 * Implementation of the IModel interface using mongoose models
 */
export class ModelBase implements IModel {
    protected model_: Model<Document>;

    /**
     * Creates a new ModelBase
     *
     * @param name Name of the model
     * @param schema Schema of the model
     */
    constructor(name: string, schema: Schema) {
        this.model_ = model(name, schema);
    }

    /**
     * @inheritdoc
     */
    create(params: any): Document {
        return new this.model_(params);
    }

    /**
     * @inheritdoc
     */
    findOne(params: any, callback: (err: any, record: Document) => void) {
        this.model_.findOne(params, callback);
    }
}

/**
 * Exports
 */
export default IModel;
