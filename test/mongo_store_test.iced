expect = require("chai").expect
IoC = require "../app/bootstrap"
{make_esc} = require "iced-error"

if process.env.NETWORK_TESTS isnt "true" then return

describe "MongoStore", ->
    @timeout 10000

    # Store the previous environment
    env = process.env.NODE_ENV

    # Force production environment to get the mongo storage
    process.env.NODE_ENV = "production"

    # Get the mongo store factory
    store_factory = IoC.create "store"
    store = store_factory.create "test"

    # Get back to the previous environment
    process.env.NODE_ENV = env

    # Before all the tests, setup some values in the store
    beforeEach (done) ->
        esc = make_esc done
        await store.insert "object", id: 0, esc(defer())
        done()

    # After each test, delete the eventual remaining object file
    afterEach (done) ->
        esc = make_esc done
        await store.delete "object", esc(defer())
        done()

    it "should return null on no value", (done) ->
        esc = make_esc done
        await store.find "nothing", esc(defer(value))
        expect(value).to.equal null
        done()

    it "should save an object", (done) ->
        esc = make_esc done
        await store.find "object", esc(defer(value))
        expect(value.id).to.equal 0
        done()

    it "should update an object", (done) ->
        esc = make_esc done
        await store.update "object", {id: 1}, esc(defer())
        await store.find "object", esc(defer(first))
        expect(first.id).to.equal 1
        done()

    it "should delete an object", (done) ->
        esc = make_esc done
        await store.delete "object", esc(defer())
        await store.find "object", esc(defer(first))
        expect(first).to.equal null
        done()

    it "should not return the same object twice", (done) ->
        esc = make_esc done
        await store.find "object", esc(defer(first))
        first.id = 1
        await store.find "object", esc(defer(second))
        expect(first).to.not.equal second
        expect(second.id).to.equal 0
        done()
