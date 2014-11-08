should = require "should"
api = require "../lib"
Registrar = api.Registrar

API_USERNAME = process.env.REGISTRAR_API_USERNAME || ""
API_PASSWORD = process.env.REGISTRAR_API_PASSWORD || ""

describe 'Registrar', ->
  before ->
    @registrar = new Registrar(API_USERNAME, API_PASSWORD)

  describe 'Course catalog', ->
    it 'can fetch ACCT 101', (done) ->
      @registrar.course 'ACCT', 101, (result) ->
        result.service_meta.error_text.should.be.empty
        result.result_data[0].course_number.should.equal "101"
        done()

    it 'can fetch CIS 121', (done) ->
      @registrar.course 'CIS', '121', (result) ->
        result.service_meta.error_text.should.be.empty
        result.result_data[0].course_number.should.equal "121"
        done()

    it 'can fetch ENGL 40', (done) ->
      @registrar.course 'ENGL', '40', (result) ->
        result.service_meta.error_text.should.be.empty
        result.result_data[0].department.should.equal "ENGL"
        done()

    it 'errors on nonexistent courses', (done) ->
      @registrar.course 'ABC', '120', (result) ->
        result.service_meta.error_text.should.be.empty
        done()

    it 'errors on nonexistent courses', (done) ->
      @registrar.course 'CIS', '087', (result) ->
        result.service_meta.error_text.should.be.empty
        done()

    it 'errors on nonexistent courses', (done) ->
      @registrar.course 'CIS', '87', (result) ->
        result.service_meta.error_text.should.be.empty
        done()

  it 'can fetch a section of CIS 110', (done) ->
    @registrar.section 'CIS', '110', '001', (result) ->
      result.result_data[0].should.have.property('recitations')
      done()

  it 'can fetch courses from CIS department', (done) ->
    @registrar.department 'CIS', (result) ->
      console.log(result)
      result.service_meta.should.have.property('current_page_number', 1)
      result.service_meta.should.have.property('number_of_pages', 7)
      result.result_data.should.have.lengthOf(20)
      done()

  it 'should handle page number parameter correctly', (done) ->
    @registrar.department 'CIS', {page_number: 2}, (result) ->
      result.service_meta.should.have.property('current_page_number', 2)
      done()

  it 'should handle results per page parameter correctly', (done) ->
    @registrar.department 'CIS', {results_per_page: 40}, (result) ->
      result.service_meta.should.have.property('results_per_page', 40)
      result.service_meta.should.have.property('number_of_pages', 7)
      result.should.have.lengthOf(40)
      done()

  it 'should handle both page number and result count parameters', (done) ->
    @registrar.department 'CIS',
      results_per_page: 40,
      page_number: 2,
    , (result) ->
      result.service_meta.should.have.property('page_number', 2)
      result.service_meta.should.have.property('number_of_pages', 7)
      result.result_data.should.have.lengthOf(40)
      done()
