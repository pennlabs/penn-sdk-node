/**
 * @fileoverview A client object for accessing the Penn Registrar API.
 */
var request = require('request')


/**
 * The root API URL
 * @const {string}
 */
var API_ROOT = 'https://esb.isc-seo.upenn.edu/8091/open_data/'

/**
 * The map of API endpoints
 * @const {Object.<string>}
 */
var ENDPOINTS = {
  CATALOG: API_ROOT + 'course_info',
  SEARCH: API_ROOT + 'course_section_search',
  SEARCH_PARAMS: API_ROOT + 'course_section_search_parameters'
}


/**
 * Client object for the registrar API
 * @param {string} accountId The ISC-provided account ID
 * @param {string} password The ISC-provided password
 * @constructor
 */
function Registrar(accountId, password) {
  this.id = accountId
  this.password = password
}

/**
 * Make a signed request to the API and handle API errors
 * @param {string} url
 * @param {Object=} params Any URL params to append to the request
 * @param {function(Error, Object)} cb A Node-style callback taking an error and the JSON result.
 */
Registrar.prototype.request = function (url, params, cb) {
  if (typeof params == 'function') {
    cb = params
    params = {}
  }

  var req = {
    url: url,
    qs: params,
    headers: {
      'Authorization-Bearer': this.id,
      'Authorization-Token': this.password
    }
  }

  request.get(req, function (err, res, body) {
    var json = JSON.parse(body)
    var apiErr = json.service_meta.error_text

    if (!err && apiErr) {
      err = new Error(apiErr)
    }

    cb(err, json)
  })
}

/**
 * Iterate through the items in a paged API request
 * @param {string} url
 * @param {Object=} params
 * @param {?function(Object, number)} func The function to call on each item, which takes the item
 *     and the index of that item
 * @param {function(Error, Array.<Object>)} fin The funciton to call when all items have been
 *     iterated through
 */
Registrar.prototype.iterRequest = function (url, params, func, fin) {
  if (typeof params == 'function') {
    func = params
    params = {}
  }
  params.page_number = 1

  var idx = 0
  var all = []

  // Recursively called callback for .request()
  var self = this
  function onPage(err, data) {
    // Exit immediately on error, so iterater function doesn't have to take an error parameter
    if (err) {
      throw err
    }

    data = data.result_data
    all.concat(data)
    data.forEach(function (item, localIdx) {
      func && func(item, idx + localIdx)
    })

    var meta = data.service_meta
    if (meta.page_number !== meta.next_page_number) {
      params.page_number += 1
      self.request(url, params, onPage)
    } else {
      fin && fin(null, all)
    }
  }

  try {
    this.request(url, params, onPage)
  } catch (err) {
    fin && fin(err, null)
  }
}

/**
 * Get the catalog info for a given course
 * @param {string} dept
 * @param {string} courseNum
 * @param {function(Error, Object)} cb A Node-style callback where the data is a course
 *     info object.
 */
Registrar.prototype.course = function (dept, courseNum, cb) {
  this.request(ENDPOINTS.CATALOG + '/' + dept + '/' + courseNum, function (err, data) {
    cb(err, data.result_data[0] || null)
  })
}

/**
 * Iterate through the course-info objects in a given department
 * @param {string} dept
 * @param {?function(Object, number)} func The function to call on each course info object, which
 *     takes the course info object and the index of that course info object
 * @param {function(Error, Array.<Object>)=} cb The final function to call once all course info
 *     objects have been handled.
 */
Registrar.prototype.department = function (dept, func, cb) {
  this.iterRequest(ENDPOINTS.CATALOG + '/' + dept, func, cb)
}

/**
 * Search for course sections based on the given parameters, and iterate through them
 * @param {Object} params
 * @param {?function(Object, number)} func The function to call on each section object, which
 *     takes the section object and the index of that section
 * @param {function(Error, Array.<Object>)=} cb The final function to call once all section
 *     objects have been handled.
 */
Registrar.prototype.searchSections = function (params, func, cb) {
  this.iterRequest(ENDPOINTS.SEARCH, params, func, cb)
}

/**
 * Get the search parameters and possible values
 * @param {function(Error, Object.<Object.<string>>)} cb A Node-style
 *     callback where the data is a map of parameters to a map from possible
 *     values for those parameters to their descriptions.
 */
Registrar.prototype.searchParams = function (cb) {
  this.request(ENDPOINTS.SEARCH_PARAMS, function (err, data) {
    cb(err, (data.result_data && data.result_data[0]) || null)
  })
}

module.exports = {
  ENDPOINTS: ENDPOINTS,
  API_ROOT: API_ROOT,
  Registrar: Registrar
}
