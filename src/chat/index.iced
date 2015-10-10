extend = require 'xtend'
{EventEmitter} = require 'events'
xmppClient = require 'node-xmpp-client'
jstoxml = require 'jstoxml'

module.exports = class TeemoChat extends EventEmitter
    constructor: (options) ->
        settings =
            debug: false
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

        # Debug logging module
        debugmod = require './debug'
        @Debug = new debugmod.Debug @

    connect: =>
        @Client = client = new xmppClient
            jid: @Settings.username + '@pvp.net'
            password: 'AIR_' + @Settings.password
            host: @Settings.server
            port: @Settings.port
            reconnect: true
            legacySSL: true # riot uses legacy ssl xmpp

        @Debug.info 'Connecting to League of Legends chat server...'

        client.on 'online', (data) =>
            @.emit 'connected', data
            @Debug.success "Connected to chat servers as #{data.jid}."
            # Send presence
            presence = # Default presence for xml
                body:
                    profileIcon: 1
                    level: 30
                    statusMsg: 'Teemo.js by Nexerq'
                    rankedWins: 777 # Not shown in new client
                    gameStatus: 'outOfGame'
                    rankedLeagueName: 'github.com/nicholastay' # Not shown in new client
                    rankedLeagueDivision: '' # Not shown in new client
                    rankedLeagueTier: 'DIAMOND' # Not shown in new client

            # Extend user presence options (directly into the body) if presence settings options are set
            presence.body = extend presence.body, @Settings.presence if @Settings.presence

            client.send new xmppClient.Stanza('presence', {type: 'available'}).c('show').t('chat').up().c('status').t(jstoxml.toXML(presence))

        client.on 'error', (err) =>
            @.emit 'error', err
            @Debug.error err

        client.on 'offline', =>
            @.emit 'offline'
            @Debug.info 'Offline from League of Legends chat.'

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
                        if not stanza.attrs.name then from = stanza.attrs.from else from = stanza.attrs.from
                        @Debug.info 'Received friend request from: ' + from
                        if @Settings.autoAcceptFriendRequests
                            @acceptFriendRequest stanza.attrs.from
                            @Debug.info "Automatically accepted friend request from #{from} as per config"
                    when 'unsubscribe'
                        @.emit 'unfriended', stanza.attrs.from
                        @Debug.info "#{stanza.attrs.from} unfriended this account"
                    when 'unavailable'
                        @.emit 'wentOffline', stanza.attrs.from
                        @Debug.info "Friend #{stanza.attrs.from} has went offline"
            else if stanza.is 'message'
                # stanza.children[0].children[0] is where the message data is, weird.
                @.emit 'pm', stanza.attrs.from, stanza.children[0].children[0] if stanza.attrs.type is 'chat'
                @Debug.log "Received message from #{stanza.attrs.from}: #{stanza.children[0].children[0]}"

    pm: (to, message) => # Private message send
        return new Error 'There is no client created to connect to League.' if not @Client
        stanza = new xmppClient.Stanza 'message',
            to: to
            type: 'chat'
        stanza.c('body').t(message)
        @Client.send stanza
        @Debug.log "Sent message to #{to}: #{message}"

    raw: (data) => # Raw xmpp.Stanza sends
        @Client.send data

    acceptFriendRequest: (to) =>
        @Client.send new xmppClient.Stanza 'presence',
            to: to
            type: 'subscribe'
        @Debug.info 'Accepted friend request from: ' + to
