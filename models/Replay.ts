import * as mongoose from "mongoose";

// How to setup our model
function setup(storage)
{
    var schema = new mongoose.Schema(
    {
        id: String,
        title: String,
        description: String
    });

    schema.virtual("link").get(() => { return storage.link(this.id + ".osr") });

    return mongoose.model("Replay", schema);
}

// Electrolyte exports
exports = module.exports = setup;
exports["@singleton"] = true;
exports["@require"] = [ "Storage" ];
