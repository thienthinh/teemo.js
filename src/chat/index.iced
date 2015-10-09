extend = require 'xtend'
{EventEmitter} = require 'events'
xmppClient = require 'node-xmpp-client'

module.exports = class TeemoChat extends EventEmitter
    constructor: (options) ->
        settings =
            username: ''
            password: ''
            region: 'na'
            port: 5223

        @Settings = extend settings, options
        # User can define their own platformid / server
        if not @Settings.server # If they have defined their server skip this step, eg garena / chatroom servers?
            if not @Settings.platformId # If a new platform id emerges skip this step and server straight away
                switch @Settings.region.toLowerCase()
                    when 'euw' then @Settings.platformId = 'euw1'
                    when 'eune' then @Settings.platformId = 'eun1'
                    when 'na' then @Settings.platformId = 'na2'
                    when 'pbe' then @Settings.platformId = 'pbe1'
                    when 'oce' then @Settings.platformId = 'oc1'
                    when 'br' then @Settings.platformId = 'br'
                    when 'tr' then @Settings.platformId = 'tr'
                    when 'ru' then @Settings.platformId = 'ru'
                    when 'lan' then @Settings.platformId = 'la1'
                    when 'las' then @Settings.platformId = 'las2'
            @Settings.server = "chat.#{@Settings.platformId}.lol.riotgames.com"

        # Init event emitter
        EventEmitter.call @

    connect: =>
        @Client = client = new xmppClient
            jid: @Settings.username + '@pvp.net'
            password: 'AIR_' + @Settings.password
            host: @Settings.server
            port: @Settings.port
            reconnect: true
            legacySSL: true # riot uses legacy ssl xmpp

        client.on 'online', => @.emit 'connected'
