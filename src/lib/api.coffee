request = require "request"

class Penn
  apiHost: "https://esb.isc-seo.upenn.edu/8091/open_data/"

  constructor: (@username, @password) ->

  api: (endpoint, params, cb) ->
    # Optional params argument
    if typeof params is "function"
      cb = params
      params = {}

    request
      url: "#{@apiHost}#{endpoint}"
      method: "GET"
      qs: params
      headers:
        "Content-Type": "application/json; charset=utf-8"
        "Authorization-Bearer": @username
        "Authorization-Token": @password
    , (err, body, response) ->
      json = JSON.parse(body)
      if err or json.service_meta.error_text
        cb err
      cb json
    return

  iterRequest: (endpoint, params, cb) ->
    # Optional params argument
    if typeof params is "function"
      cb = params
      params = {}
    params.page_number = 1

    idx = 0
    all = []

    onPage = (err, data) ->
      throw err if err

      data = data.result_data
      all.concat data

      meta = data.service_meta
      if meta.page_number isnt meta.next_page_number
        params.page_number += 1
        @api endpoint, params, onPage
      else
        cb and cb(all)
      return

    try
      @api endpoint, params, onPage
    catch err
      cb and cb(null)
    return


class Registrar extends Penn
  ENDPOINTS =
    CATALOG: 'course_info'
    SEARCH: 'course_section_search'
    SEARCH_PARAMS: 'course_section_search_parameters'

  course: (dept, courseNum, cb) ->
    @api("#{ENDPOINTS.CATALOG}/#{dept}/#{courseNum}", cb)

  section: (dept, courseNum, sectionNum, cb) ->
    @api(ENDPOINTS.SEARCH, {course_id: dept + courseNum + sectionNum}, cb)

  department: (dept, cb) ->
    @iterRequest("#{ENDPOINTS.CATALOG}/#{dept}", cb)

  searchParams: (cb) ->
    @api(ENDPOINTS.SEARCH_PARAMS, cb)


class Directory extends Penn
  ENDPOINTS =
    PERSON_DETAILS: 'directory_person_details'

  personDetails: (person, cb) ->
    @api("#{ENDPOINTS.PERSON_DETAILS}/#{person}", cb)


module.exports.Penn = Penn
module.exports.Registrar = Registrar
module.exports.Directory = Directory
