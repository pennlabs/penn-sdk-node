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
      result.should.be.ok
      result.should.be.an.Array
      result.length.should.be.above 100
      done()
