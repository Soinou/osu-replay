Promise = require "promise"

class Http

    get: (url) -> return @request "GET", url, null
    post: (url, data) -> return @request "POST", url, data
    request: (method, url, data) ->
        return new Promise (resolve, reject) ->
            request = new XMLHttpRequest()
            request.onreadystatechange = () ->
                if @readyState is 4
                    if @status is 200 or @status is 304 then resolve @response
                    else reject @response
            request.onerror = () -> reject @response
            request.open method, url, true
            request.setRequestHeader "Content-Type", "application/json"
            request.send JSON.stringify data

module.exports = new Http
