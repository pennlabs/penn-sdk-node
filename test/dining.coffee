assert = require "assert"
api = require "../lib"
Dining = api.Dining

API_USERNAME = process.env.DINING_API_USERNAME || ""
API_PASSWORD = process.env.DINING_API_PASSWORD || ""

describe 'Dining', ->
  before ->
    @dining = new Dining(API_USERNAME, API_PASSWORD)

  describe 'venues', ->
    it 'should have Hill House in venues', (done) ->
      @dining.venues (result) ->
        result.result_data.document.venue.should.containDeep [{"name": "Hill House"}]
        done()

    it 'should have Arch Cafe in venues', (done) ->
      @dining.venues (result) ->
        result.result_data.document.venue.should.containDeep [{"name": "Arch Cafe"}]
        done()

    it 'should have hours for venues', (done) ->
      @dining.venues (result) ->
        result.result_data.document.venue[0].should.have.property('dateHours')
        done()

  describe 'menus', ->
    it 'should have the menu for Commons', (done) ->
      @dining.dailyMenu '593', (result) ->
        result.result_data.Document.location.should.equal "University of Pennsylvania 1920 Commons"
        done()

    it 'should have multiple meals per day', (done) ->
      @dining.dailyMenu '593', (result) ->
        result.result_data.Document.tblMenu.tblDayPart.length.should.be.above 1
        done()

    it 'should have lots of food stations', (done) ->
      @dining.dailyMenu '593', (result) ->
        result.result_data.Document.tblMenu.tblDayPart[0].tblStation.length.should.be.above 4
        done()
