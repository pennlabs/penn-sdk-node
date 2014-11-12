should = require "should"
api = require "../lib"
Map = api.Map

API_USERNAME = process.env.NEWS_EVENTS_MAP_API_USERNAME || ""
API_PASSWORD = process.env.NEWS_EVENTS_MAP_API_PASSWORD || ""

describe 'Map', ->
  before ->
    @map = new Map(API_USERNAME, API_PASSWORD)

  describe 'search', ->
    it 'should have the Ralston House', (done) ->
      @map.search {'description': 'geriatric'}, (result) ->
        result.result_data[0].title.should.equal "Ralston House"
        done()

    it 'should get all the libraries', (done) ->
      @map.search {'description': "library"}, (result) ->
        result.result_data.should.be.an.Array
        result.result_data.length.should.be.above 10
        done()

    it 'should get all the libraries by type', (done) ->
      @map.search {'building_type_id': 11033292}, (result) ->
        result.result_data.should.be.an.Array
        result.result_data.length.should.be.above 10
        result.result_data.should.containDeep [title: "Biomedical Library - Johnson Pavilion"]
        done()

  it 'should get the list of all building filters', (done) ->
    @map.filterParams (result) ->
      result.result_data[0].should.have.property "asset_type_parameters_map"
      result.result_data[0].should.have.property "building_type_parameters_map"
      result.result_data[0].should.have.property "school_parameters_map"
      done()
