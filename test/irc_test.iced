expect = require("chai").expect
IoC = require "../app/bootstrap"
{make_esc} = require "iced-error"

client = IoC.create "irc_client"

describe "osu!irc client", ->

    it "should not send messages until flush is called", (done) ->

        flushing = false

        client.send "Soinou", "I should not be sent", (err) ->
            if not flushing then throw new Error "Message was sent"

        flushing = true
        client.flush()
        done()

    it "should send only five messages per flush",(done) ->

        client.send "One", "Should be sent", (err) ->

        client.send "Two", "Should be sent", (err) ->

        client.send "Three", "Should be sent", (err) ->

        client.send "Four", "Should be sent", (err) ->

        client.send "Five", "Should be sent", (err) ->

        client.send "Six", "Should not be sent", (err) ->
            throw new Error "Sent six messages"

        client.flush()

        done()
