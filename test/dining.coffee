assert = require "assert"
api = require "../lib"
Dining = api.Dining

API_USERNAME = process.env.DINING_API_USERNAME || ""
API_PASSWORD = process.env.DINING_API_PASSWORD || ""

describe 'Dining', ->
  before ->
    @dining = new Dining(API_USERNAME, API_PASSWORD)

  it 'should have Hill House in venues', (done) ->
    @dining.venues (result) ->
      result.result_data.document.venue.should.containDeep [{"name": "Hill House"}]
      done()
