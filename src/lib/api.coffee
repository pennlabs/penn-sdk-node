request = require "request"

ENDPOINTS =
  CATALOG: 'course_info'
  SEARCH: 'course_section_search'
  SEARCH_PARAMS: 'course_section_search_parameters'
  PERSON_DETAILS: 'directory_person_details'

class Penn
  apiHost: "https://esb.isc-seo.upenn.edu/8091/open_data/"

  constructor: (@username, @password) ->

  api: (endpoint, cb) ->
    request
      url: "#{@apiHost}#{endpoint}"
      method: "GET"
      headers:
        "Content-Type": "application/json; charset=utf-8"
        "Authorization-Bearer": @username
        "Authorization-Token": @password
    , (err, body, response) ->
      if err
        cb err
      cb JSON.parse(response)
    return

class Registrar extends Penn
  course: (dept, courseNum, cb) ->
    @api("#{ENDPOINTS.CATALOG}/#{dept}/#{courseNum}", cb)

  searchParams: (cb) ->
    @api(ENDPOINTS.SEARCH_PARAMS, cb)

class Directory extends Penn
  personDetails: (person, cb) ->
    @api("#{ENDPOINTS.PERSON_DETAILS}/#{person}", cb)

module.exports.Penn = Penn
module.exports.Registrar = Registrar
module.exports.Directory = Directory
