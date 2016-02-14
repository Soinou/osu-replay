FastMap = require "collections/fast-map"

# Defines an utility to process osu! mods
class Mods
    # Creates a new utility thingy
    constructor: ->
        @mods_ = new FastMap
        @mods_.set 1 << 0, "nofail"
        @mods_.set 1 << 1, "easy"
        @mods_.set 1 << 2, "NoVideo"
        @mods_.set 1 << 3, "hidden"
        @mods_.set 1 << 4, "hardrock"
        @mods_.set 1 << 5, "suddendeath"
        @mods_.set 1 << 7, "relax"
        @mods_.set 1 << 8, "halftime"
        @mods_.set 1 << 10, "flashlight"
        @mods_.set 1 << 11, "auto"
        @mods_.set 1 << 12, "spunout"
        @mods_.set 1 << 13, "relax2"
        @mods_.set 1 << 14, "perfect"
        @mods_.set 1 << 15, "key4"
        @mods_.set 1 << 16, "key5"
        @mods_.set 1 << 17, "key6"
        @mods_.set 1 << 18, "key7"
        @mods_.set 1 << 19, "key8"
        # @mods_.set 1015808, "KeyMod"
        @mods_.set 1 << 20, "fadein"
        @mods_.set 1 << 21, "random"
        # @mods_.set 1 << 22, "LastMod"
        # @mods_.set 2077883, "FreeMod"
        # Where is the 23 damn it
        @mods_.set 1 << 24, "key9"
        # I don't get how this one works but nvm
        @mods_.set 26844546, "key2"
        # Doesn't exist, wth ?
        # @mods_.set 1 << 25, "key10"
        @mods_.set 1 << 26, "key1"
        @mods_.set 1 << 27, "key3"

    # Get a mod list from the given mod number
    get_mods: (mods) ->
        mod_list = []

        for mod in @mods_.keys()
            if (mods & mod) == mod
                mod_list.push @mods_.get mod

        # Hard coded because this is dumb
        if (mods & 512) == 512 then mod_list.push "nightcore"
        else if (mods & 64) == 64 then mod_list.push "doubletime"

        return mod_list

exports = module.exports = new Mods
