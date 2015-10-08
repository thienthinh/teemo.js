extend = require 'xtend'
path = require 'path'
fs = require 'fs'

module.exports = class TeemoApi
    constructor: (options) ->
        settings =
            apiKey: ''
            region: 'na'

        @Settings = extend settings, options
        @Core = {}
        
        # Load core modules (base requests, etc)
        for mod in fs.readdirSync path.resolve __dirname, 'core'
            continue if path.extname mod isnt '.js' or '.iced'
            modName = mod.replace('.js', '').replace('.iced', '')
            coreMod = require path.resolve __dirname, 'core', modName
            @.Core[modName] = new coreMod[modName] @

        # Load endpoint modules
        for mod in fs.readdirSync path.resolve __dirname, 'endpoints'
            continue if path.extname mod isnt '.js' or '.iced'
            modName = mod.replace('.js', '').replace('.iced', '')
            endpointMod = require path.resolve __dirname, 'endpoints', modName
            @[modName] = new endpointMod[modName] @