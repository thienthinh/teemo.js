extend = require 'xtend'

class TeemoApi
    constructor: (options) ->
        settings =
            apiKey: ''
            region: 'na'

        @settings = extend settings, options

    raw: (endpoint, cb) ->
        return require('./request') @, endpoint, cb

module.exports = TeemoApi