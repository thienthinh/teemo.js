Teemo = require '../src/teemo.iced'
repl = require 'repl'

# Use command line args for user/pass
if not process.argv[3]
    console.log 'Usage: iced chat-client.iced <username> <password>'
    process.exit 1


lolChat = new Teemo.chat
    username: process.argv[2]
    password: process.argv[3]
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