Teemo = require '../src/teemo.iced'
repl = require 'repl'

# Use command line args for user/pass
if not process.argv[3]
    console.log 'Usage: iced chat-client.iced <username> <password>'
    process.exit 1

lolChat = new Teemo.chat
    debug: true
    username: process.argv[2]
    password: process.argv[3]
    autoAcceptFriendRequests: true

# Events
# Echo bot
lolChat.on 'pm', (from, message) ->
    lolChat.pm from, 'echo: ' + message

lolChat.connect()

# REPL for easy debugging
replServer = repl.start 'TeemoChat> '
replServer.context.lolChat = lolChat
console.log '\n'