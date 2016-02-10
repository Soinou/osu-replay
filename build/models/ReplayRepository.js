var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import { Inject } from "inversify";
/**
 * Implementation of the IReplay interface
 */
export class Replay {
    /**
     * Creates a new Replay
     *
     * @param storage_ Storage service
     * @param document Document to get data from
     */
    constructor(storage_, document) {
        this.storage_ = storage_;
        document = document || {};
        this.id_ = document.id || "No ID";
        this.title_ = document.id || "No Title";
        this.description_ = document.description || "No Description";
    }
    /**
     * @inheritdoc
     */
    id() {
        return this.id_;
    }
    /**
    * @inheritdoc
    */
    title() {
        return this.title_;
    }
    /**
     * @inheritdoc
     */
    description() {
        return this.description_;
    }
    /**
     * @inheritdoc
     */
    link() {
        return this.storage_.link(this.id_);
    }
}
/**
 * Implementation of the IReplayRepository interface
 */
export let ReplayRepository = class {
    /**
     * Creates a new ReplayRepository
     *
     * @param storage_ Storage service
     * @param database_ Database service
     */
    constructor(storage_, database_) {
        this.storage_ = storage_;
        this.database_ = database_;
    }
    /**
     * @inheritdoc
     */
    find(id, callback) {
        this.database_.find(id, (err, document) => {
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
    insert(id, replay, callback) {
        this.database_.insert(id, replay, callback);
    }
};
ReplayRepository = __decorate([
    Inject("IStorage", "IDatabase"), 
    __metadata('design:paramtypes', [Object, Object])
], ReplayRepository);
//# sourceMappingURL=ReplayRepository.js.map