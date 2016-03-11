# Represents an users controller
module.exports = class UsersController

    dependencies: -> [
        "path",
        "shortid",
        "logger",
        "irc"
    ]

    initialized: ->

    # Installs the controller to the given express app
    install: (app) ->

    ###
    # GET /users
    _index: (req, res) -> res.redirect "/"

    # GET /users/create
    _create: (req, res) =>
        step = req.session.step or 1
        res.render "users/create-" + step

    # POST /users
    _store: (req, res) =>
        step = req.session.step or 1

        switch step
            when 1 then @_store_one req, res
            when 2 then @_store_two req, res
            when 3 then @_store_three req, res

    # POST /users (Step one)
    _store_one: (req, res) =>
        req.session.step = 1

        req.check("username", "Username must not be empty").notEmpty()
        req.check("username", "Username must be 3 - 15 characters long").isLength({min: 3, max: 15})

        # Validate inputs
        errors = req.validationErrors(true)

        if errors then return res.status(422).render "users/create-1", errors: errors

        req.session.username = req.body.username
        req.session.code = shortid.generate()

        irc.send req.session.username, "Your code is: " + req.session.code

        req.session.step = 2
        res.redirect "/users/create"

    # POST /users (Step two)
    _store_two: (req, res) =>
        req.session.step = 2

        req.check("code", "Code must not be empty").notEmpty()
        req.check("code", "Code must be 7-14 characters long").isLength({min: 7, max: 14})

        # Validate inputs
        errors = req.validationErrors(true)

        if req.session.code isnt req.body.code
            errors = errors or {}
            errors.code = {param: "code", msg: "Code does not match", value: req.body.code}

        if errors then return res.status(422).render "users/create-2", errors: errors

        req.session.step = 3
        res.redirect "/users/create"

    # POST /users (Step three)
    _store_three: (req, res) =>
        req.session.step = 3

        # Validate inputs
        errors = req.validationErrors(true)

        if req.body.password isnt req.body.password_confirmation
            errors = errors or {}

        if errors then return res.status(422).render "users/create-3", errors: errors

        user = {
            username: req.session.username,
            password: req.body.password,
            email: req.body.email
        }

        res.json user

    # GET /users/:id
    _show: (req, res) =>
        res.redirect "/"

    # GET /users/:id/edit
    _edit: (req, res) =>
        res.redirect "/"

    # POST /users/:id
    _update: (req, res) =>
        res.redirect "/"

    _on_connection: (socket) =>
        user_ = null
        code_ = null

        # Once the username is entered, we need to send the code
        socket.on "check_user", (user) =>
            user_ = user
            code_ = shortid.generate()
            irc.send user_, "Your code is: " + code_
            socket.emit "good_user"

        socket.on "check_code", (code) ->
            if code is code_
                socket.emit "good_code"
            else
                socket.emit "bad_code"
    ###
