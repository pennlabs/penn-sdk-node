should = require "should"
api = require "../lib"
Transit = api.Transit

API_USERNAME = process.env.TRANSIT_API_USERNAME || ""
API_PASSWORD = process.env.TRANSIT_API_PASSWORD || ""

describe 'Transit', ->
  before ->
    @transit = new Transit(API_USERNAME, API_PASSWORD)

  describe 'stop inventory', ->
    it 'should have the Quad', (done) ->
      @transit.stops (result) ->
        result.result_data.should.containDeep ["BusStopName": "The Quad, 3700 Spruce St."]
        done()

    it 'should have multiple stops', (done) ->
      @transit.stops (result) ->
        result.result_data.should.be.an.Array
        result.result_data.length.should.be.above 20
        done()

  it 'should display many stops in configuration', (done) ->
    @transit.config (result) ->
      result
        .result_data
        .ConfigurationData
        .numStops.should.be.above 100
      done()

  it 'should display the prediction endpoint', (done) ->
    @transit.predict (result) ->
      result.result_data.PredictionData.should.be.an.Object
      result.result_data.PredictionData.StopPredictions.should.be.an.Array
      done()

  it 'should display the recent arrivals', (done) ->
    @transit.arrived (result) ->
      result.result_data.ArrivalStatusData.should.be.an.Array
      done()
