# Simple values
class Value
    constructor: (@value_) ->

    get: -> @value_

# Libraries directly return the content of the file
class Library
    constructor: (@path_) -> @file_ = null

    get: (kernel) ->
        if not @file_?
            @file_ = require @path_

        return @file_

class Type
    constructor: (@path_) -> @file_ = null

    get: (kernel, name, args...) ->
        if not @file_? then @file_ = require @path_

        instance = new @file_ args...

        if instance.created
                instance.created()

        if instance.dependencies?
            for dependency in instance.dependencies()
                instance[dependency] = kernel.resolve dependency, name

        if instance.initialized
            instance.initialized()

        return instance

# Factories describe how to create things
class Factory
    constructor: (@path_, @create_) ->
        @file_ = null
        @factory_ = null
        if @create_ then @file_ = new Type @path_

    get: (kernel, name) ->
        if not @file_?
            @file_ = require @path_

        if not @factory_?
            if @create_
                @factory_ = create: (args...) =>
                    @file_.get kernel, name, args...
            else
                @factory_ = @file_

        return @factory_

# Services are instantiated as we need them
class Service
    constructor: (@path_) ->
        @file_ = new Type @path_
        @instance_ = null

    get: (kernel, name) ->
        if not @instance_? then @instance_ = @file_.get kernel, name

        return @instance_

# Main kernel
class Kernel
    constructor: -> @components_ = {}

    set: (name, value) ->
        @components_[name] = new Value value

    library: (name, path) ->
        path = path or name

        @components_[name] = new Library path

    type: (name, path) ->
        @components_[name] = new Type path

    factory: (name, path, create) ->
        @components_[name] = new Factory path, create

    service: (name, path) ->
        @components_[name] = new Service path

    resolve: (name, asker) ->
        asker = asker or "Main"
        component = @components_[name]

        if not component?
            message = "Component '" + asker + "'"
            message += " requires component '" + name + "'"
            message += " which couldn't be found"
            throw new Error message

        return component.get this, name

module.exports = new Kernel
