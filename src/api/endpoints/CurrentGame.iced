class exports.CurrentGame
    constructor: (@TeemoApi) ->
        # Get platform id from region codes
        switch @TeemoApi.Settings.region.toLowerCase()
            when 'euw' then @platformId = 'EUW1'
            when 'eune' then @platformId = 'EUN1'
            when 'na' then @platformId = 'NA1'
            when 'oce' then @platformId = 'OC1'
            when 'br' then @platformId = 'BR1'
            when 'tr' then @platformId = 'TR1'
            when 'ru' then @platformId = 'RU'
            when 'lan' then @platformId = 'LA1'
            when 'las' then @platformId = 'LA2'
            when 'kr' then @platformId = 'KR'
            else @platformId = @TeemoApi.Settings.region.toUpperCase() # fallback

        @info =
            fullName: 'current-game-v1.0'
            name: 'current-game'
            version: '1.0'
            endpoint: "/observer-mode/rest/consumer/getSpectatorGameInfo/#{@platformId}"

    getGameInfo: (summonerId, cb) =>
        return new Error 'No summoner ID given' if not summonerId
        @TeemoApi.Core.Request.raw "#{@info.endpoint}/#{summonerId}", cb