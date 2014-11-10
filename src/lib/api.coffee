request = require "request"

class Penn
  apiHost: "https://esb.isc-seo.upenn.edu/8091/open_data/"

  constructor: (@username, @password) ->
    if not @username or not @password
      throw new Error("Username and password required")

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
      json = JSON.parse(response)
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
    self = this

    onPage = (data) ->
      all = all.concat data.result_data

      meta = data.service_meta
      if meta.current_page_number isnt meta.next_page_number
        params.page_number += 1
        self.api endpoint, params, onPage
      else
        cb and cb(all)
      return

    @api endpoint, params, onPage


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

  search: (params, cb) ->
    @iterRequest(ENDPOINTS.SEARCH, params, cb)

  searchParams: (cb) ->
    @api(ENDPOINTS.SEARCH_PARAMS, cb)


class Directory extends Penn
  ENDPOINTS =
    SEARCH: 'directory'
    PERSON_DETAILS: 'directory_person_details'

  search: (params, cb) ->
    @api(ENDPOINTS.SEARCH, params, cb)

  personDetails: (person, cb) ->
    @api("#{ENDPOINTS.PERSON_DETAILS}/#{person}", cb)


class Dining extends Penn
  ENDPOINTS =
    MENUS: 'dining/menus'
    VENUES: 'dining/venues'

  venues: (cb) ->
    @api(ENDPOINTS.VENUES, cb)

  dailyMenu: (building, cb) ->
    @api("#{ENDPOINTS.MENUS}/daily/#{building}", cb)

  weeklyMenu: (building, cb) ->
    @api("#{ENDPOINTS.MENUS}/weekly/#{building}", cb)

class Transit extends Penn
  ENDPOINTS =
    STOPS: 'transit/stopinventory'
    CONFIG: 'transit/511/Configuration'
    PREDICT: 'transit/511/Prediction'

  stops: (cb) ->
    @api(ENDPOINTS.STOPS, cb)

  config: (cb) ->
    @api(ENDPOINTS.CONFIG, cb)

  predict: (cb) ->
    @api(ENDPOINTS.PREDICT, cb)


module.exports.Penn = Penn
module.exports.Registrar = Registrar
module.exports.Directory = Directory
module.exports.Dining = Dining
module.exports.Transit = Transit
