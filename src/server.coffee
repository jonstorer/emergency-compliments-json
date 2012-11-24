redis = require('redis-url').connect(process.env.REDISTOGO_URL || 'localhost')
http  = require 'http'
App   = require 'strata'

App.use App.commonLogger
App.use App.contentType, 'application/json'
App.use App.contentLength
App.use App.file, require('path').resolve('./public'), 'index.html'

# GET /v1/compliments.json
App.get '/v1/compliments', ( env, next ) ->
  cacheKey = '/v1/compliments'
  redis.get cacheKey, ( error, compliments ) ->
    if compliments?.length
      App.Response( compliments ).send(next)
    else
      data = ''
      http.get 'http://emergencycompliment.com/js/compliments.js', ( response ) ->
        response.on 'data', ( chunk ) -> data += chunk
        response.on 'end', ->
          eval( data.toString() )
          compliments = JSON.stringify( compliments )
          redis.set( cacheKey, compliments )
          App.Response( compliments ).send(next)

App.run({ port: ( process.env.PORT || 5294 ) })
