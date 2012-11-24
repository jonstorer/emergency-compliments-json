App  = require 'strata'
port = process.env.PORT || 5294

App.use App.commonLogger
App.use App.contentType, 'application/json'
App.use App.contentLength
App.use App.file, require('path').resolve('./public'), 'index.html'

# strategies
getCompliments = require './strategies/eval'

# GET /v1/compliments.json
App.get '/v1/compliments', ( env, next ) ->
  getCompliments ( compliments ) ->
    App.Response(JSON.stringify(compliments)).send(next)

App.run({ port: port })
