_              = require 'lodash'
request        = require 'request'
enableDestroy  = require 'server-destroy'
testResponse   = require './test-response.json'
octobluExpress = require '../'

describe 'Octoblu Express', ->
  beforeEach (done) ->
    app = octobluExpress({ disableLogging: true })

    app.get '/throw/error', (req, res) =>
      throw new Error 'hello'

    app.get '/uncaught/error', (req, res) =>
      unknownfunc 'called with'

    app.get '/success', (req, res) =>
      res.sendStatus(204)

    app.get '/test', (req, res) =>
      res.send testResponse

    app.get '/failure', (req, res) =>
      res.sendStatus(500)

    app.post '/body', (req, res) =>
      return res.sendStatus(422) unless _.isPlainObject(req.body)
      return res.sendStatus(204)

    @server = app.listen undefined, done
    enableDestroy @server
    @baseUrl = "http://localhost:#{@server.address().port}"

  afterEach ->
    @server.destroy()

  describe 'GET /uncaught/error', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/uncaught/error',
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 500 status code', ->
      expect(@response.statusCode).to.equal 500

  describe 'GET /throw/error', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/throw/error',
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 500 status code', ->
      expect(@response.statusCode).to.equal 500

  describe 'GET /success', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/success',
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 204 status code', ->
      expect(@response.statusCode).to.equal 204

  describe 'GET /failure', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/failure',
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 500 status code', ->
      expect(@response.statusCode).to.equal 500

  describe 'GET /healthcheck', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/healthcheck',
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 200 status code', ->
      expect(@response.statusCode).to.equal 200

    it 'should have a the right body', ->
      expect(@body.online).to.be.true

  describe 'GET /version', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/version',
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 200 status code', ->
      expect(@response.statusCode).to.equal 200

    it 'should have a the right body', ->
      expect(@body.version).to.exist

  describe 'GET /test - gzip', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/test',
        gzip: true,
        json: true,
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 200 status code', ->
      expect(@response.statusCode).to.equal 200

    it 'should have the right body', ->
      expect(@body).to.deep.equal testResponse

  describe 'GET /favicon.ico', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/favicon.ico'
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 200 status code', ->
      expect(@response.statusCode).to.equal 200

  describe 'GET /favicon.ico', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/favicon.ico'
      }
      request.get options, (error, @response, @body) =>
        done error

    it 'should have a 200 status code', ->
      expect(@response.statusCode).to.equal 200

  describe 'POST /body - json', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/body'
        json:
          something: true
      }
      request.post options, (error, @response, @body) =>
        done error

    it 'should have a 204 status code', ->
      expect(@response.statusCode).to.equal 204

  describe 'POST /body - urlencoded', ->
    beforeEach (done) ->
      options = {
        @baseUrl,
        uri: '/body'
        form:
          something: true
      }
      request.post options, (error, @response, @body) =>
        done error

    it 'should have a 204 status code', ->
      expect(@response.statusCode).to.equal 204
