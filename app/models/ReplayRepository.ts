import { Document, Model, model, Schema } from "mongoose";

import IDatabase from "../services/Database";
import IStorage from "../services/Storage";

import { Inject } from "inversify";

/**
 * Represents a Replay
 */
export interface IReplay {
    /**
     * Replay id
     */
    id(): string;

    /**
     * Replay title
     */
    title(): string;

    /**
     * Replay description
     */
    description(): string;

    /**
     * Replay file link
     */
    link(): string;
}

/**
 * Implementation of the IReplay interface
 */
export class Replay implements IReplay {
    /**
     * Replay ID
     */
    protected id_: string;

    /**
     * Replay Title
     */
    protected title_: string;

    /**
     * Replay Description
     */
    protected description_: string;

    /**
     * Creates a new Replay
     *
     * @param storage_ Storage service
     * @param document Document to get data from
     */
    constructor(protected storage_: IStorage, document: any) {
        document = document || {};

        this.id_ = document.id || "No ID";
        this.title_ = document.id || "No Title";
        this.description_ = document.description || "No Description";
    }

    /**
     * @inheritdoc
     */
    id(): string {
        return this.id_;
    }

    /**
    * @inheritdoc
    */
    title(): string {
        return this.title_;
    }

    /**
     * @inheritdoc
     */
    description(): string {
        return this.description_;
    }

    /**
     * @inheritdoc
     */
    link(): string {
        return this.storage_.link(this.id_);
    }
}

/**
 * Represents a Replay repository
 */
interface IReplayRepository {
    /**
     * Finds a replay based on its id
     *
     * @param id Replay ID
     * @param callback Callback called once the replay is found
     */
    find(id: string, callback: (err: any, replay: IReplay) => void);

    /**
     * Inserts a new Replay to the repository
     *
     * @param id Replay ID
     * @param replay Replay to insert
     * @param callback Callback called once the replay is inserted
     */
    insert(id: string, replay: any, callback: (err: any) => void);
}

/**
 * Implementation of the IReplayRepository interface
 */
@Inject("IStorage", "IDatabase")
export class ReplayRepository implements IReplayRepository {
    /**
     * Creates a new ReplayRepository
     *
     * @param storage_ Storage service
     * @param database_ Database service
     */
    constructor(protected storage_: IStorage, protected database_: IDatabase) {
    }

    /**
     * @inheritdoc
     */
    find(id: string, callback: (err: any, replay: IReplay) => void) {
        this.database_.find(id, (err: any, document: any) => {
            if (err) {
                callback(err, null);
            }
            else if (!document) {
                callback(null, null);
            }
            else {
                callback(null, new Replay(this.storage_, document));
            }
        });
    }

    /**
     * @inheritdoc
     */
    insert(id: string, replay: any, callback: (err: any) => void) {
        this.database_.insert(id, replay, callback);
    }
}

/**
 * Exports
 */
export default IReplayRepository;
