path               = require 'path'
cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
compression        = require 'compression'
OctobluRaven       = require 'octoblu-raven'
enableDestroy      = require 'server-destroy'
favicon            = require 'serve-favicon'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
expressVersion     = require 'express-package-version'

class Express
  constructor: (options) ->
    @_setOptions options
    app = express()
    enableDestroy app
    @_raven { app }
    @_middlewares { app }
    return app

  _setOptions: (options={}) =>
    {
      @disableLogging,
      @disableCors,
      @logSuccesses,
      @faviconPath,
      @bodyLimit,
      @logFn,
      @logFormat,
    } = options
    @disableLogging ?= process.env.DISABLE_LOGGING == "true"
    @logSuccesses ?= process.env.LOG_SUCCESSES == "true"
    @slowLoggingMin ?= parseInt(process.env.SLOW_LOGGING_MIN || 1000)
    @logFormat ?= 'short' if process.env.NODE_ENV == 'production'
    @logFormat ?= 'dev'
    @faviconPath ?= path.join(__dirname, '..', 'assets', 'favicon.ico')
    @bodyLimit ?= '1mb'

  _raven: ({ app }) =>
    octobluRaven = new OctobluRaven({ @logFn })
    octobluRaven.handleExpress({ app })

  _skip: (request, response) =>
    shouldLog=false
    shouldNotLog=true
    return shouldNotLog if @disableLogging
    return shouldLog if @logSuccesses
    responseTime = morgan['response-time']?(request, response)
    return shouldLog if responseTime > @slowLoggingMin
    return shouldLog if response.statusCode > 300
    return shouldNotLog

  _middlewares: ({ app }) =>
    app.use compression()
    app.use meshbluHealthcheck()
    app.use expressVersion format: '{"version": "%s"}'
    app.use morgan @logFormat, { immediate: false, skip: @_skip }
    app.use favicon @faviconPath
    app.use bodyParser.urlencoded { limit: @bodyLimit, extended: true }
    app.use bodyParser.json { limit: @bodyLimit }
    app.use cors() unless @disableCors
    app.options '*', cors() unless @disableCors

module.exports = Express
