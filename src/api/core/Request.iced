request = require 'request'
extend = require 'xtend'

class exports.Request
    constructor: (@TeemoApi) ->

    raw: (endpoint, options, cb) =>
        return cb new Error 'No API key set, aborting request.' if not @TeemoApi.Settings.apiKey
        await request
            baseUrl: "https://#{@TeemoApi.Settings.region}.api.pvp.net"
            uri: endpoint
            qs: extend {api_key: @TeemoApi.Settings.apiKey}, options 
        , defer err, res, body
        return cb err if err

        # Check for status codes
        return cb new Error 'Bad request (HTTP status code 400)' if res.statusCode is 400
        return cb new Error 'Unauthorized (HTTP status code 401)' if res.statusCode is 401
        return cb new Error 'Forbidden (HTTP status code 403)' if res.statusCode is 403
        return cb new Error 'Rate limit exceeded (HTTP status code 429)' if res.statusCode is 429
        return cb new Error 'Internal server error (HTTP status code 500)' if res.statusCode is 500
        return cb new Error 'Service unavailable (HTTP status code 503)' if res.statusCode is 503
        return cb new Error "Request failed, status code returned: #{res.statusCode}" if res.statusCode isnt 200

        return cb null, JSON.parse body
