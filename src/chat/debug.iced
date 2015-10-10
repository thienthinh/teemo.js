strftime = require 'strftime'

class exports.Debug
    constructor: (@TeemoChat) ->

    log: (message) ->
        if @TeemoChat.Settings.debug is true
            console.log "[#{strftime '%l:%M%P'}] #{message}"

    info: (message) -> @log 'info: ' + message
    success: (message) -> @log 'success: ' + message
    error: (message) -> @log 'ERROR: ' + message