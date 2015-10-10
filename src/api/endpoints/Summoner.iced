class exports.Summoner
    constructor: (@TeemoApi) ->
        @info =
            fullName: 'summoner-v1.4'
            name: 'summoner'
            version: '1.4'
            endpoint: "/api/lol/#{@TeemoApi.Settings.region}/v1.4/summoner"

    # /summoner-v1.4 has no options, also here we make sure the id/name is present or throw error
    # Also has some stuff like /summoner/IDHERE/then_more_params so the more params is under afterId
    get: (id, endpoint, afterId, cb) =>
        return cb new Error 'No Name/ID defined to lookup' if not id
        @TeemoApi.Core.Request.raw "#{@info.endpoint}#{endpoint}/#{id.toString()}#{afterId}", cb

    getSummonersByName: (name, cb) => @get name, '/by-name', '', cb
    getSummonersById: (id, cb) => @get id, '', '', cb
    getSummonerNamesById: (id, cb) => @get id, '', '/name', cb
    getMasteriesBySummonerId: (id, cb) => @get id, '', '/masteries', cb
    getRunesBySummonerId: (id, cb) => @get id, '', '/runes', cb