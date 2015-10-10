extend = require 'xtend'
{EventEmitter} = require 'events'
xmppClient = require 'node-xmpp-client'
jstoxml = require 'jstoxml'

module.exports = class TeemoChat extends EventEmitter
    constructor: (options) ->
        settings =
            username: ''
            password: ''
            region: 'na'
            port: 5223
            autoAcceptFriendRequests: false

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

        client.on 'online', (data) =>
            @.emit 'connected', data
            # Send presence
            presence = # Default presence for xml
                body:
                    profileIcon: 1
                    level: 30
                    statusMsg: 'Teemo.js by Nexerq'
                    rankedWins: 777
                    gameStatus: 'outOfGame'
                    rankedLeagueName: 'github.com/nicholastay'
                    rankedLeagueDivision: ''
                    rankedLeagueTier: 'DIAMOND'

            # Extend user presence options (directly into the body) if presence settings options are set
            presence.body = extend presence.body, @Settings.presence if @Settings.presence

            client.send new xmppClient.Stanza('presence', {type: 'available'}).c('show').t('chat').up().c('status').t(jstoxml.toXML(presence))

        client.on 'error', (err) => @.emit 'error', err
        client.on 'stanza', (stanza) =>
            @LastMessage = stanza # More of a debug thing

            # XMPP basic types, if user wants to access that
            @.emit 'stanza', stanza
            @.emit 'error', stanza if stanza.attrs.type is 'error'
            @.emit 'presence', stanza if stanza.is 'presence'
            @.emit 'message', stanza if stanza.is 'message'

            # More specific stanza digging in, possibly league specific
            if stanza.is 'presence'
                switch stanza.attrs.type
                    when 'subscribe'
                        @.emit 'friendRequest', stanza.attrs.from, stanza.attrs.name
                        @acceptFriendRequest stanza.attrs.from if @Settings.autoAcceptFriendRequests
                    when 'unsubscribe' then @.emit 'unfriended', stanza.attrs.from
                    when 'unavailable' then @.emit 'wentOffline', stanza.attrs.from
            else if stanza.is 'message'
                # stanza.children[0].children[0] is where the message data is, weird.
                @.emit 'pm', stanza.attrs.from, stanza.children[0].children[0] if stanza.attrs.type is 'chat'

    pm: (to, message) => # Private message send
        return new Error 'There is no client created to connect to League.' if not @Client
        stanza = new xmppClient.Stanza 'message',
            to: to
            type: 'chat'
        stanza.c('body').t(message)
        @Client.send stanza

    raw: (data) => # Raw xmpp.Stanza sends
        @Client.send data

    acceptFriendRequest: (to) =>
        @Client.send new xmppClient.Stanza 'presence',
            to: to
            type: 'subscribe'
