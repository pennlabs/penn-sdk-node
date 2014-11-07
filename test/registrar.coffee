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

  it 'can fetch ENGL 40', ->
    registrar = new Registrar(API_USERNAME, API_PASSWORD)
    registrar.course 'ENGL', '40', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.department.should.equal "ENGL"

  it 'errors on nonexistent courses', ->
    registrar = new Registrar(API_USERNAME, API_PASSWORD)
    registrar.course 'ABC', '120', (result) ->
      result.error_text.should.notEqual ""
    registrar.course 'CIS', '087', (result) ->
      result.error_text.should.notEqual ""
    registrar.course 'CIS', '87', (result) ->
      result.error_text.should.notEqual ""

  it 'can fetch a section of CIS 110', ->
    registrar = new Registrar(API_USERNAME, API_PASSWORD)
    registrar.section 'CIS', '110', '001', (result) ->
      result.result_data.should.have.property('recitations')
