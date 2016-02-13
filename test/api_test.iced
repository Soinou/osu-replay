expect = require("chai").expect
IoC = require "../app/bootstrap"

api = IoC.create "api"

if process.env.NETWORK_TESTS isnt "true" then return

describe "osu!api", ->
    @timeout(10000)

    it "should get ciel de la nuit by default", (done) ->
        await api.get_user null, defer err, user
        expect(err).to.equal null
        expect(user).to.not.equal null
        expect(user.user_id).to.equal "2497930"
        expect(user.username).to.equal "ciel de la nuit"
        done()
        return

    it "should get the big black by default", (done) ->
        await api.get_beatmap null, defer err, beatmap
        expect(err).to.equal null
        expect(beatmap).to.not.equal null
        expect(beatmap.beatmapset_id).to.equal "41823"
        expect(beatmap.artist).to.equal "The Quick Brown Fox"
        expect(beatmap.title).to.equal "The Big Black"
        done()
        return

    it "should be able to get peppy by username", (done) ->
        await api.get_user u: "peppy", defer err, user
        expect(err).to.equal null
        expect(user).to.not.equal null
        expect(user.user_id).to.equal "2"
        expect(user.username).to.equal "peppy"
        done()
        return

    it "should be able to get peppy by id", (done) ->
        await api.get_user { u: "2", type: "id" }, defer err, user
        expect(err).to.equal null
        expect(user).to.not.equal null
        expect(user.user_id).to.equal "2"
        expect(user.username).to.equal "peppy"
        done()
        return

    it "should be able to get blue zenith by set id", (done) ->
        await api.get_beatmap s: 292301, defer err, beatmap
        expect(err).to.equal null
        expect(beatmap).to.not.equal null
        expect(beatmap.beatmapset_id).to.equal "292301"
        expect(beatmap.artist).to.equal "xi"
        expect(beatmap.title).to.equal "Blue Zenith"
        done()
        return

    it "should be able to get blue zenith by beatmap id", (done) ->
        await api.get_beatmap b: 658127, defer err, beatmap
        expect(err).to.equal null
        expect(beatmap).to.not.equal null
        expect(beatmap.beatmapset_id).to.equal "292301"
        expect(beatmap.beatmap_id).to.equal "658127"
        expect(beatmap.artist).to.equal "xi"
        expect(beatmap.title).to.equal "Blue Zenith"
        done()
        return
