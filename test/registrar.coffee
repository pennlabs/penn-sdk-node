assert = require "assert"
api = require "../lib"
Registrar = api.Registrar

API_USERNAME = process.env.REGISTRAR_API_USERNAME || ""
API_PASSWORD = process.env.REGISTRAR_API_PASSWORD || ""

describe 'Registrar', ->
  before ->
    @registrar = new Registrar(API_USERNAME, API_PASSWORD)

  it 'can fetch ACCT 101', ->
    @registrar.course 'ACCT', 101, (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "101"

  it 'can fetch CIS 121', ->
    @registrar.course 'CIS', '121', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.course_number.should.equal "121"

  it 'can fetch ENGL 40', ->
    @registrar.course 'ENGL', '40', (result) ->
      result.service_meta.error_text.should.equal ""
      result.result_data.department.should.equal "ENGL"

  it 'errors on nonexistent courses', ->
    @registrar.course 'ABC', '120', (result) ->
      result.error_text.should.notEqual ""
    @registrar.course 'CIS', '087', (result) ->
      result.error_text.should.notEqual ""
    @registrar.course 'CIS', '87', (result) ->
      result.error_text.should.notEqual ""

  it 'can fetch a section of CIS 110', ->
    @registrar.section 'CIS', '110', '001', (result) ->
      result.result_data.should.have.property('recitations')

  it 'can fetch courses from CIS department', ->
    @registrar.department 'CIS', (result) ->
      result.meta.should.have.property('current_page_number', 1)
      result.meta.should.have.property('number_of_pages', 7)
      result.should.have.lengthOf(20)

  it 'should handle page number parameter correctly', ->
    @registrar.department 'CIS', {page_number: 2}, (result) ->
      result.meta.should.have.property('current_page_number', 2)

  it 'should handle results per page parameter correctly', ->
    @registrar.department 'CIS', {results_per_page: 40}, (result) ->
      result.meta.should.have.property('results_per_page', 40)
      result.meta.should.have.property('number_of_pages', 7)
      result.should.have.lengthOf(40)

  it 'should handle both page number and result count parameters', ->
    @registrar.department 'CIS',
      results_per_page: 40,
      page_number: 2,
    , (result) ->
      result.meta.should.have.property('page_number', 2)
      result.meta.should.have.property('number_of_pages', 7)
      result.should.have.lengthOf(40)

  it 'should be able to search courses', ->
    @registrar.search
      course_id: 'hist'
      instructor: 'kors'
    , (result) ->
      result.result_data.ok

  it 'should get a valid list of search parameters', ->
    @registrar.searchParams (result) ->
      result.should.have.property('activity_map')
