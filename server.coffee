App        = require 'strata'
publicRoot = require('path').resolve('./public')
port       = process.env.PORT || 5294

# strategies
fetchCompliments = require 'strategies/eval'

App.use App.commonLogger
App.use App.contentType, 'application/json'
App.use App.contentLength
App.use App.file, publicRoot, 'index.html'

# GET /api/v1/compliments.json
App.get '/v1/compliments.json', ( env, callback ) ->
  fetchCompliments ( compliments ) ->
    App.Response( JSON.stringify( compliments ) ).send( callback )

server.run({ port: port })
