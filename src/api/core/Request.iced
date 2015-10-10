request = require 'request'
extend = require 'xtend'

class exports.Request
    constructor: (@TeemoApi) ->

    raw: (endpoint, options..., cb) =>
        # Optional options variable
        options = options[0]

        return cb new Error 'No API key set, aborting request.' if not @TeemoApi.Settings.apiKey

        qs = {api_key: @TeemoApi.Settings.apiKey}
        if options
            qs = extend qs, options

        @TeemoApi.Core.Debug.info "Trying API request to #{endpoint}"
        await request
            baseUrl: "https://#{@TeemoApi.Settings.region}.api.pvp.net"
            uri: endpoint
            qs: qs
        , defer err, res, body
        return cb err if err

        # Check for status codes
        switch res.statusCode
            when 200 then break
            when 400 then return @TeemoApi.Core.Debug.error 'Bad request (HTTP status code 400)', cb
            when 401 then return @TeemoApi.Core.Debug.error 'Unauthorized (HTTP status code 401)', cb
            when 403 then return @TeemoApi.Core.Debug.error 'Forbidden (HTTP status code 403)', cb
            when 404 then return @TeemoApi.Core.Debug.error 'Not found (HTTP status code 404)', cb
            when 429 then return @TeemoApi.Core.Debug.error 'Rate limit exceeded (HTTP status code 429)', cb
            when 500 then return @TeemoApi.Core.Debug.error 'Internal server error (HTTP status code 500)', cb
            when 503 then return @TeemoApi.Core.Debug.error 'Service unavailable (HTTP status code 503)', cb
            else return @TeemoApi.Core.Debug.error "Request failed (not HTTP 200), status code returned: #{res.statusCode}", cb

        @TeemoApi.Core.Debug.success "#{endpoint} data returned"
        return cb null, JSON.parse body
