class exports.Champion
    constructor: (@TeemoApi) ->
        @info =
            fullName: 'champion-v1.2'
            name: 'champion'
            version: '1.2'
            endpoint: "/api/lol/#{@TeemoApi.Settings.region}/v1.2/champion"

    getChampions: (options..., cb) =>
        # Optional argument 'options' (https://github.com/jashkenas/coffeescript/issues/1091)
        options = options[0]
        qs = {}
        if options
            qs.freeToPlay = true if options.freeToPlay is true
        await @TeemoApi.Core.Request.raw @info.endpoint, qs, defer err, resp
        return cb err if err
        return cb null, resp

    getChampionById: (id, cb) =>
        return cb new Error 'No champion ID given' if not id
        await @TeemoApi.Core.Request.raw "#{@info.endpoint}/#{id.toString()}", defer err, resp
        return cb err if err
        return cb null, resp