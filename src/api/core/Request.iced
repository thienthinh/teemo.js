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
        return cb new Error "Request failed, status code returned: #{res.statusCode}" if res.statusCode isnt 200
        return cb null, JSON.parse body