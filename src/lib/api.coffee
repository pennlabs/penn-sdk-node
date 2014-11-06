request = require "request"

API_ROOT = "https://esb.isc-seo.upenn.edu/8091/open_data/"

ENDPOINTS =
  CATALOG: API_ROOT + 'course_info'
  SEARCH: API_ROOT + 'course_section_search'
  SEARCH_PARAMS: API_ROOT + 'course_section_search_parameters'

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

module.exports.Penn = Penn
module.exports.Registrar = Registrar
