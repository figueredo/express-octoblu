path               = require 'path'
cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
compression        = require 'compression'
OctobluRaven       = require 'octoblu-raven'
favicon            = require 'serve-favicon'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
expressVersion     = require 'express-package-version'

class Express
  constructor: (options={}) ->
    { @disableLogging, @disableCors, @logSuccesses } = options
    { @faviconPath, @bodyLimit } = options
    { @octobluRaven, @logFn } = options
    { @logFormat } = options
    @disableLogging ?= process.env.DISABLE_LOGGING == "true"
    @logSuccesses ?= process.env.LOG_SUCCESSES == "true"
    @slowLoggingMin ?= parseInt(process.env.SLOW_LOGGING_MIN || 1000)
    @logFormat ?= 'short' if process.env.NODE_ENV == 'production'
    @logFormat ?= 'dev'
    @faviconPath ?= path.join(__dirname, '..', 'assets', 'favicon.ico')
    @bodyLimit ?= '1mb'
    @_app = express()
    @_raven()
    @_middlewares()

  app: =>
    return @_app

  _skip: (request, response) =>
    shouldLog=false
    shouldNotLog=true
    return shouldNotLog if @disableLogging
    return shouldLog if @logSuccesses
    responseTime = morgan['response-time']?(request, response)
    return shouldLog if responseTime > @slowLoggingMin
    return shouldLog if response.statusCode > 300
    return shouldNotLog

  _raven: =>
    @octobluRaven ?= new OctobluRaven {}, { @logFn }
    @ravenExpress = @octobluRaven.express()

  _middlewares: =>
    @_app.use @ravenExpress.sendErrorHandler()
    @_app.use @ravenExpress.meshbluAuthContext()
    @_app.use compression()
    @_app.use meshbluHealthcheck()
    @_app.use expressVersion format: '{"version": "%s"}'
    @_app.use morgan @logFormat, { immediate: false, skip: @_skip }
    @_app.use favicon @faviconPath
    @_app.use bodyParser.urlencoded { limit: @bodyLimit, extended: true }
    @_app.use bodyParser.json { limit: @bodyLimit }
    @_app.use cors() unless @disableCors
    @_app.options '*', cors() unless @disableCors
    @_app.use @ravenExpress.requestHandler()
    @_app.use @ravenExpress.errorHandler()
    @_app.use @ravenExpress.badRequestHandler()

module.exports = Express
