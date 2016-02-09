import { Document, Model, model, Schema } from "mongoose";

import IModel, { ModelBase } from "./Model";
import IStorage from "../services/Storage";

import { Inject } from "inversify";

/**
 * Represents a Replay model
 */
interface IReplay extends IModel
{ }

/**
 * Implementation of the IReplay interface
 */
@Inject("IStorage")
export class Replay extends ModelBase {
    /**
     * Creates a new Replay
     *
     * @param storage Storage service
     */
    constructor(storage: IStorage) {
        var schema = new Schema(
            {
                id: String,
                title: String,
                description: String
            });

        schema.virtual("link").get(function() {
            return storage.link(this.id + ".osr")
        });

        super("Replay", schema);
    }
}

/**
 * Exports
 */
export default IReplay;
