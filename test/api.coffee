API_KEY = ''
assert = require "assert"
Penn = require "../lib"

API_USERNAME = process.env.REGISTRAR_API_USERNAME || ""
API_PASSWORD = process.env.REGISTRAR_API_PASSWORD || ""

describe 'Penn', ->

  it 'can fetch ACCT 101', ->
    penn = new Penn(API_USERNAME, API_PASSWORD)
    penn.api 'course_info/ACCT/101/', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "101"
