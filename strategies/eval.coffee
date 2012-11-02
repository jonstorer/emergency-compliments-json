redis = require('redis-url').connect(process.env.REDISTOGO_URL)
http  = require 'http'

module.exports = fetchCompliments = ( callback ) ->
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
