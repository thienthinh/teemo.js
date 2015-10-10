class exports.LolStaticData
    constructor: (@TeemoApi) ->
        @info =
            fullName: 'lol-static-data-v1.2'
            name: 'lol-static-data'
            version: '1.2'
            endpoint: "/api/lol/static-data/#{@TeemoApi.Settings.region}/v1.2"

    get: (endpoint, options..., cb) => @TeemoApi.Core.Request.raw "#{@info.endpoint}#{endpoint}", options, cb

    getChampions: (options..., cb) => @get '/champion', options, cb
    getChampionById: (id, options..., cb) => @get "/champion/#{id.toString()}", options, cb
    getItems: (options..., cb) => @get '/item', options, cb
    getItemById: (id, options..., cb) => @get "/item/#{id.toString()}", options, cb
    getLanguageStrings: (options..., cb) => @get '/language-strings', options, cb
    getLanguages: (cb) => @get '/languages', cb
    getMapData: (options..., cb) => @get '/map', options, cb
    getMasteries: (options..., cb) => @get '/mastery', options, cb
    getMasteryById: (id, options..., cb) => @get "/mastery/#{id.toString()}", options, cb
    getRealmData: (cb) => @get '/realm', cb
    getRunes: (options..., cb) => @get '/rune', options, cb
    getRuneById: (id, options..., cb) => @get "/rune/#{id.toString()}", options, cb
    getSummonerSpells: (options..., cb) => @get '/summoner-spell', options, cb
    getSummonerSpellById: (id, options..., cb) => @get "/summoner-spell/#{id.toString()}", options, cb
    getVersions: (cb) => @get '/versions', cb