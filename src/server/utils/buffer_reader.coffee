module.exports = class BufferReader

    dependencies: -> ["leb", "Int64"]

    constructor: (@buffer_) ->
        @offset_ = 0

    read_byte: ->
        value = @buffer_.readInt8 @offset_
        @offset_ += 1
        return value

    read_short: ->
        value = @buffer_.readInt16LE @offset_
        @offset_ += 2
        return value

    read_int: ->
        value = @buffer_.readInt32LE @offset_
        @offset_ += 4
        return value

    read_long: ->
        value = @Int64.create @buffer_, @offset_
        @offset_ += 8
        return value.toNumber true

    read_uleb128: ->
        uint = @leb.decodeInt32 @buffer_, @offset_
        @offset_ = uint.nextIndex
        return uint.value

    read_string: ->
        indicator = @read_byte()
        if indicator == 0
            return ""
        else
            uint = @read_uleb128()
            value = @buffer_.toString "utf8", @offset_, @offset_ + uint
            @offset_ += uint
            return value
