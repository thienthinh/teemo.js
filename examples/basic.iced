Teemo = require '../src/teemo.iced'

lolApi = new Teemo.api
    apiKey: ''

await lolApi.Request.raw '/api/lol/na/v1.4/summoner/by-name/Nexerq', defer err, resp
console.log resp