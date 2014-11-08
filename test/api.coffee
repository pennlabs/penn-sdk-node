should = require "should"
api = require "../lib"
Penn = api.Penn

API_USERNAME = process.env.REGISTRAR_API_USERNAME || ""
API_PASSWORD = process.env.REGISTRAR_API_PASSWORD || ""

describe 'Penn', ->
  before ->
    @penn = new Penn(API_USERNAME, API_PASSWORD)

  it 'can fetch ACCT 101', (done) ->
    @penn.api 'course_info/ACCT/101/', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data[0].course_number.should.equal "101"
      done()

  it 'can fetch CIS 121', (done) ->
    @penn.api 'course_info/CIS/121/', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data[0].course_number.should.equal "121"
      done()

  it 'can search for ACCT 101', (done) ->
    @penn.api 'course_section_search?course_id=ACCT101', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data[0].course_number.should.equal "101"
      result.result_data[0].course_department.should.equal "ACCT"
      result.result_data[0].requirements[0].value.should.equal "REC"
      done()
