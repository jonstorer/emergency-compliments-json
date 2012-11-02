App        = require 'strata'
publicRoot = require('path').resolve('./public')
port       = process.env.PORT || 5294

App.use App.commonLogger
App.use App.contentType, 'application/json'
App.use App.contentLength
App.use App.file, publicRoot, 'index.html'

# strategies
fetchCompliments = require 'strategies/eval'

# GET /v1/compliments.json
App.get '/v1/compliments.json', ( env, callback ) ->
  fetchCompliments ( compliments ) ->
    App.Response( JSON.stringify( compliments ) ).send( callback )

server.run({ port: port })
