assert = require "assert"
api = require "../lib"
Penn = api.Penn

API_USERNAME = process.env.REGISTRAR_API_USERNAME || ""
API_PASSWORD = process.env.REGISTRAR_API_PASSWORD || ""

describe 'Penn', ->

  it 'can fetch ACCT 101', ->
    penn = new Penn(API_USERNAME, API_PASSWORD)
    penn.api 'course_info/ACCT/101/', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "101"

  it 'can fetch CIS 121', ->
    penn = new Penn(API_USERNAME, API_PASSWORD)
    penn.api 'course_info/CIS/121/', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "121"

  it 'can search for ACCT 101', ->
    penn = new Penn(API_USERNAME, API_PASSWORD)
    penn.api 'course_section_search?course_id=ACCT101', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "101"
      result.result_data.course_department.should.equal "ACCT"
      result.result_data.requirements[0].value.should.equal "REC"
