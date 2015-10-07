extend = require 'xtend'
path = require 'path'
fs = require 'fs'

module.exports = class TeemoApi
    constructor: (options) ->
        settings =
            apiKey: ''
            region: 'na'

        @Settings = extend settings, options
        
        # Load core modules (base requests, etc)
        for mod in fs.readdirSync path.resolve __dirname, 'core'
            continue if path.extname mod isnt '.js' or '.iced'
            modName = mod.replace('.js', '').replace('.iced', '')
            coreMod = require path.resolve __dirname, 'core', modName
            @[modName] = new coreMod[modName] @