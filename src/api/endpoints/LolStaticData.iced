class exports.LolStaticData
    constructor: (@TeemoApi) ->
        @info =
            fullName: 'lol-static-data-v1.2'
            name: 'lol-static-data'
            version: '1.2'
            endpoint: "/api/lol/static-data/#{@TeemoApi.Settings.region}/v1.2"

    get: (endpoint, options, cb) =>
        options = options[0]
        @TeemoApi.Core.Request.raw "#{@info.endpoint}#{endpoint}", options, cb

    # No ids/variables required to be passed
    getChampions: (options..., cb) => @get '/champion', options, cb
    getItems: (options..., cb) => @get '/item', options, cb
    getLanguageStrings: (options..., cb) => @get '/language-strings', options, cb
    getLanguages: (cb) => @get '/languages', cb
    getMapData: (options..., cb) => @get '/map', options, cb
    getMasteries: (options..., cb) => @get '/mastery', options, cb
    getRealmData: (cb) => @get '/realm', cb
    getRunes: (options..., cb) => @get '/rune', options, cb
    getSummonerSpells: (options..., cb) => @get '/summoner-spell', options, cb
    getVersions: (cb) => @get '/versions', cb


    # Only get the data if the id variable is defined (otherwise stupid)
    getWithIdIfExists: (id, options, endpoint, cb) =>
        options = options[0]
        return cb new Error 'No ID defined to lookup' if not id
        @get "#{endpoint}/#{id.toString()}", options, cb

    getChampionById: (id, options..., cb) => @getWithIdIfExists id, options, '/champion', cb
    getItemById: (id, options..., cb) => @getWithIdIfExists id, options, '/item', cb
    getMasteryById: (id, options..., cb) => @getWithIdIfExists id, options, '/mastery', cb
    getRuneById: (id, options..., cb) => @getWithIdIfExists id, options, '/rune', cb
    getSummonerSpellById: (id, options..., cb) => @getWithIdIfExists id, options, '/summoner-spell', cb