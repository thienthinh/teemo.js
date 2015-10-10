Teemo = require '../src/teemo.iced'
repl = require 'repl'

lolChat = new Teemo.chat
    username: ''
    password: ''
    autoAcceptFriendRequests: true


# Events
lolChat.on 'connected', -> console.log 'Connected to league chat as ' + lolChat.Settings.username
lolChat.on 'error', (err) -> console.log 'ERROR: ' + err

# Auto accept friend requests
lolChat.on 'friendRequest', (from, name) ->
    name = from if not name
    console.log 'Accepting friend request from: ' + name

# lolChat.on 'stanza', (stanza) ->
#     console.log stanza


# Echo bot
lolChat.on 'pm', (from, message) ->
    console.log "(pm) #{from} said: #{message}"
    lolChat.pm from, 'echo: ' + message

lolChat.connect()

# REPL for easy debugging
replServer = repl.start 'TeemoChat> '
replServer.context.lolChat = lolChat
console.log '\n'