# teemo.js

A library for League of Legends in node.js/iced-coffee. It supports both API functions as well as a chat client which makes connection to Riot's XMPP servers easier than before. *(as a side note, connections to their XMPP chat servers are not supported by Riot and can break any time)*

Refer to [examples](https://github.com/nicholastay/teemo.js/tree/master/examples) for some basic usage of the library.

Basic installation:
```
# In your project folder
$ npm install teemo.js --save

# or for the latest GitHub master
$ npm install nicholastay/teemo.js --save
```


* * *


## API
Pluggable endpoints system, as new endpoints get added or removed, or they get changed over time, they can be updated as needed.

Basic usage:
```js
var Teemo = require('teemo.js');

var lolApi = new Teemo.api({
    apiKey: 'API-KEY'
});
// ...
```

### Endpoints included
*(Any 'options' parameters are optional and can be ommitted. 'cb' means a callback and is generally required. More information on each endpoint can be read on the official Riot Developer Portal)*

* Champion (/champion)
    - getChampions(options, cb)
    - getChampionById(id, cb)
* CurrentGame (/observer-mode/rest/consumer/getSpectatorGameInfo)
    - getGameInfo(summonerId, cb)
* LolStaticData (/static-data)
    - get(id, endpoint, afterId, cb) *[this is just a raw get with a given endpoint.]*
    - getChampions(options, cb)
    - getLanguageString(options, cb)
    - getLanguages(cb)
    - getMapData(options, cb)
    - getMasteries(options, cb)
    - getRealmData(cb)
    - getRunes(options, cb)
    - getSummonerSpells(options, cb)
    - getVersions(cb)
    - getChampionById(id, options, cb)
    - getItemById(id, options, cb)
    - getMasteryById(id, options, cb)
    - getRuneById(id, options, cb)
    - getSummonerSpellById(id, options, cb)
* Summoner (/summoner)
    - get(id, endpoint, afterId, cb) *[this is just a raw get with a given endpoint. It has some calls like /summoner/IDHERE/afterId so afterId is placed there.]*
    - getSummonersByName(name, cb)
    - getSummonersById(id, cb)
    - getSummonerNamesById(id, cb)
    - getMasteriesBySummonerId(id, cb)
    - getRunesBySummonerId(id, cb)


* * *


## Chat
Chat client wrapper as described in the opening paragraph.

Basic usage:
```js
var Teemo = require('teemo.js');

var lolChat = new Teemo.chat({
    debug: true, // Spit debug messages
    username: 'USER',
    password: 'PASS',
    autoAcceptFriendRequests: true // Auto accept friend reqs, don't have to handle yourself
});
// ... probably put your event handlers here

lolChat.connect()
```

### Events
*(the parameters in brackets represent what is emitted with the event)*

* connected(data) - connected to server, and the xmpp data as a param
* error(err) - error catching -- IT IS HIGHLY RECOMMENDED TO CATCH THIS EVENT
* offline() - client went offline
* stanza(stanza) - minimal parsed xmpp stanza data
* presence(stanza) - same as `stanza` but only if it is a presence stanza
* message(stanza) - same as `stanza` but only if it is a message
* friendRequest(from, name) - received a friend request. from = username, name = friendly name (i.e. summoner name)
* unfriended(from) - unfriended. from = username
* wentOffline(from) - someone went offline. from = username
* pm(from, message) - received a PM. from = username, message = message text

### Functions / Commands
* connect() - connects to server
* pm(to, message) - private messages someone. to = username, message = text to send
* raw(data) - send raw stanza data
* acceptFriendRequest(to) - accepts a friend request. to = username


* * *


## License
Licensed under the MIT license.