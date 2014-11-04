request = require "request"

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

module.exports = Penn
