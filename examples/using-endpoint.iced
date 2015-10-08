Teemo = require '../src/teemo.iced'

lolApi = new Teemo.api
    apiKey: ''

await lolApi.Champion.getChampionById 53, defer err, resp
console.log resp