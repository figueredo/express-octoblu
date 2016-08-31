path               = require 'path'
cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
compression        = require 'compression'
OctobluRaven       = require 'octoblu-raven'
favicon            = require 'serve-favicon'
bodyParser         = require 'body-parser'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
expressVersion     = require 'express-package-version'

class Express
  constructor: ({ @disableLogging, @disableCors, @octobluRaven, @faviconPath, @bodyLimit }={}) ->
    @disableLogging ?= process.env.DISABLE_LOGGING == "true"
    @faviconPath ?= path.join(__dirname, '..', 'assets', 'favicon.ico')
    @bodyLimit ?= '1mb'
    @_app = express()
    @_raven()
    @_middlewares()

  app: =>
    return @_app

  _skip: (request, response) =>
    return true if @disableLogging
    return response.statusCode < 300

  _raven: =>
    @octobluRaven ?= new OctobluRaven
    @octobluRaven.expressBundle { app: @_app }

  _middlewares: =>
    @_app.use compression()
    @_app.use meshbluHealthcheck()
    @_app.use expressVersion format: '{"version": "%s"}'
    @_app.use morgan 'dev', { immediate: false, skip: @_skip }
    @_app.use favicon @faviconPath
    @_app.use bodyParser.urlencoded { limit: @bodyLimit, extended: true }
    @_app.use bodyParser.json { limit: @bodyLimit }
    @_app.use cors() unless @disableCors
    @_app.options '*', cors() unless @disableCors

module.exports = Express
