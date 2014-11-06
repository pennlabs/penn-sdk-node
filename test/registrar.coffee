assert = require "assert"
api = require "../lib"
Registrar = api.Registrar

API_USERNAME = process.env.REGISTRAR_API_USERNAME || ""
API_PASSWORD = process.env.REGISTRAR_API_PASSWORD || ""

describe 'Registrar', ->

  it 'can fetch ACCT 101', ->
    registrar = new Registrar(API_USERNAME, API_PASSWORD)
    registrar.course 'ACCT', 101, (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "101"

  it 'can fetch CIS 121', ->
    registrar = new Registrar(API_USERNAME, API_PASSWORD)
    registrar.course 'CIS', '121', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "121"
