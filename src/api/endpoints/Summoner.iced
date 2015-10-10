class exports.Summoner
    constructor: (@TeemoApi) ->
        @info =
            fullName: 'summoner-v1.4'
            name: 'summoner'
            version: '1.4'
            endpoint: "/api/lol/#{@TeemoApi.Settings.region}/v1.4/summoner"

    # /summoner-v1.4 has no options
    get: (endpoint, cb) => @TeemoApi.Core.Request.raw "#{@info.endpoint}#{endpoint}", cb

    getSummonersByName: (name, cb) => @get "/by-name/#{name}", cb
    getSummonersById: (id, cb) => @get "/#{id}", cb
    getSummonerNamesById: (id, cb) => @get "/#{id}/name"
    getMasteriesBySummonerId: (id, cb) => @get "/#{id}/masteries", cb
    getRunesBySummonerId: (id, cb) => @get "/#{id}/runes", cb