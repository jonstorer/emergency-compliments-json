redis     = require('redis-url').connect(process.env.REDISTOGO_URL)
AppServer = require 'strata'
http      = require 'http'

Compliments =
  all: ( callback ) ->
    redis.get 'compliments', ( error, compliments ) ->
      compliments = JSON.parse( compliments )
      if compliments?.length
        callback( compliments )
      else
        data = ''
        http.get 'http://emergencycompliment.com/js/compliments.js', ( response ) ->
          response.on 'data', ( chunk ) -> data += chunk
          response.on 'end', =>
            eval( data.toString() )
            redis.set( 'compliments', JSON.stringify( compliments ) )
            callback( compliments )

#AppServer.use AppServer.commonLogger
AppServer.use AppServer.contentType, 'application/json'
AppServer.use AppServer.contentLength

# GET /api/v1/compliments.json
AppServer.get '/api/v1/compliments.json', ( env, callback ) ->
  Compliments.all ( compliments ) ->
    AppServer.Response( JSON.stringify( compliments ) ).send( callback )

# GET /api/v1/compliments.json
AppServer.get '/', ( env, callback ) ->
  AppServer.Response( 'Emergency Compliments JSON' ).send( callback )

port = process.env.PORT || 5294
AppServer.run({ port: port })
