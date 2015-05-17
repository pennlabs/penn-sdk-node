should = require "should"
api = require "../lib"
News = api.News

API_USERNAME = process.env.NEWS_EVENTS_MAP_API_USERNAME || ""
API_PASSWORD = process.env.NEWS_EVENTS_MAP_API_PASSWORD || ""

describe 'News', ->
  before ->
    @news = new News(API_USERNAME, API_PASSWORD)

  describe 'search', ->
    it 'should have news about Gutmann', (done) ->
      @news.search "gutmann", (result) ->
        result.result_data.length.should.be.above 10
        done()
