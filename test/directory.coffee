should = require "should"
api = require "../lib"
Directory = api.Directory

API_USERNAME = process.env.DIRECTORY_API_USERNAME || ""
API_PASSWORD = process.env.DIRECTORY_API_PASSWORD || ""

describe 'Directory', ->
  before ->
    @directory = new Directory(API_USERNAME, API_PASSWORD)

  describe 'Person details', ->
    it 'can fetch details about Adel Qalieh', (done) ->
      @directory.personDetails '4ad00e45edffd2ec2180673dabf4aace', (result) ->
        result.result_data[0].list_name.should.equal "QALIEH, ADEL "
        done()

  describe 'Search', ->
    it 'can search for Alex Wissmann', (done) ->
      @directory.search {last_name: 'Wissmann'}, (result) ->
        result.result_data.should.have.lengthOf(1)
        result.result_data[0].list_name.should.equal "WISSMANN, ALEXANDER R"
        done()
