import IRepository, { MongoRepository, LocalRepository } from "../services/Repository";

import ILogger from "../services/Logger";

import { Inject } from "inversify";

/**
 * Represents a Replay repository
 */
interface IReplayRepository extends IRepository {

}

/**
 * Implementation of the IReplayRepository interface using a MongoRepository
 */
@Inject("ILogger")
export class MongoReplayRepository extends MongoRepository implements IReplayRepository {
    /**
     * Creates a new MongoReplayRepository
     */
    constructor(logger: ILogger) {
        super("replays");
        logger.success("Mongo replay repository successfully created");
    }
}

/**
 * Implementation of the IReplayRepository using a LocalRepository
 */
@Inject("ILogger")
export class LocalReplayRepository extends LocalRepository implements IReplayRepository {
    constructor(logger: ILogger) {
        super();
        logger.success("Local replay repository successfully created");
    }
}

/**
 * Exports
 */
export default IReplayRepository;
