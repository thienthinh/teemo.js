Teemo = require '../src/teemo.iced'

lolChat = new Teemo.chat
    username: ''
    password: ''

lolChat.connect()

lolChat.on 'connected', -> console.log 'Connected to league chat as ' + lolChat.Settings.username