strftime = require 'strftime'

class exports.Debug
    constructor: (@TeemoApi) ->

    log: (message) ->
        if @TeemoApi.Settings.debug is true
            console.log "[#{strftime '%l:%M%P'}] #{message}"

    info: (message) ->
        @log '[info] ' + message

    success: (message) ->
        @log '[SUCCESS] ' + message

    error: (message, callback) ->
        @log '[ERROR] ' + message
        # Optional callback for async functions
        callback new Error message if typeof callback is 'function'