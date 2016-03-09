FastMap = require "collections/fast-map"

# Defines an utility to process osu! mods
class Mods
    constructor: ->
        @mods_ = new FastMap
        @_add_mod 1 << 0, "nofail", "No Fail"
        @_add_mod 1 << 1, "easy", "Easy"
        # @_add_mod 1 << 2, "NoVideo", "No Video"
        @_add_mod 1 << 3, "hidden", "Hidden"
        @_add_mod 1 << 4, "hardrock", "Hard Rock"
        @_add_mod 1 << 5, "suddendeath", "Sudden Death"
        @_add_mod 1 << 7, "relax", "Relax"
        @_add_mod 1 << 8, "halftime", "Half Time"
        @_add_mod 1 << 10, "flashlight", "Flash Light"
        # @_add_mod 1 << 11, "auto", "Auto"
        @_add_mod 1 << 12, "spunout", "Spun Out"
        @_add_mod 1 << 13, "relax2", "Auto Pilot"
        @_add_mod 1 << 14, "perfect", "Perfect"
        @_add_mod 1 << 15, "key4", "Key 4"
        @_add_mod 1 << 16, "key5", "Key 5"
        @_add_mod 1 << 17, "key6", "Key 6"
        @_add_mod 1 << 18, "key7", "Key 7"
        @_add_mod 1 << 19, "key8", "Key 8"
        # @_add_mod 1015808, "keymod", "Key Mod"
        @_add_mod 1 << 20, "fadein", "Fade In"
        @_add_mod 1 << 21, "random", "Random"
        # @_add_mod 1 << 22, "cinema", "Cinema"
        # @_add_mod 2077883, "freemod", "Free Mod"
        # Where is the 23 damn it
        @_add_mod 1 << 24, "key9", "Key 9"
        # I don't get how this one works but nvm
        @_add_mod 26844546, "key2", "Key 2"
        # Doesn't exist, wth ?
        # @_add_mod 1 << 25, "key10", "Key 10"
        @_add_mod 1 << 26, "key1", "Key 1"
        @_add_mod 1 << 27, "key3", "Key 3"

    _add_mod: (value, id, name) ->
        @mods_.set value, {id: id, name: name}

    # Get a mod list from the given mod number
    get_mods: (mods) ->
        mod_list = []

        for mod in @mods_.keys()
            if (mods & mod) == mod
                mod_list.push @mods_.get mod

        # Hard coded because this is dumb
        if (mods & 512) == 512 then mod_list.push {id: "nightcore", name: "Night Core"}
        else if (mods & 64) == 64 then mod_list.push {id: "doubletime", name: "Double Time"}

        return mod_list

module.exports = new Mods
