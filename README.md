Penn OpenData Node SDK
=====

[![Build Status](https://travis-ci.org/pennappslabs/penn-sdk-node.svg?branch=master)](https://travis-ci.org/pennappslabs/penn-sdk-node)

This is the Penn Open Data API implementation in NodeJS, currently with support for the registrar, directory, and dining APIs.
You can view the complete API reference [here](docs/api.md).

## Install
To get started, just run

```
npm install penn-sdk
```

## Overview

```
var api = require("penn-sdk")
Registrar = api.Registrar

registrar = new Registrar("API_USERNAME", "API_PASSWORD")
registrar.course("CHEM", "241", function(result) {
  console.log(result)
})
```

## Requesting an API key

To use this library, you must first obtain an API token and password for the API you want to use, which can be done [here](https://esb.isc-seo.upenn.edu/8091/documentation/#security).

**Note**: There are separate API tokens for each API.

## Contributing

We'd love to accept pull requests! Also, file bugs or ask questions in GitHub issues if you have any problems.

### Getting Started

1. Fork the repository using GitHub's interface
2. Git clone your repository using `git clone YOUR_GIT_URL`
3. Install the required dependencies using `npm install`.
4. Start editing the CoffeeScript source files in `src`.
5. Write tests!
6. Make a pull request back to the original repository.

### Building

The SDK is written in [CoffeeScript](http://coffeescript.org/), so please make your changes in the CoffeeScript source files in `src` and they can be compiled into JavaScript using `make js`.

### Testing

You can test the work you have using `make test`, which uses [Mocha](http://mochajs.org/) to run the tests inside of the `test` directory. You should have environment variables in your shell that specify your API keys in the format `REGISTRAR_API_USERNAME` and `REGISTRAR_API_PASSWORD`.
If you prefer to have these tests run while you're editing automatically, you can run `make watch` from your terminal.

### TODO

- [ ] Open Data APIs
  - [x] Implement registrar API
  - [x] Implement directory API
  - [x] Implement dining API
  - [ ] Implement transit API
  - [ ] Implement map API
  - [ ] Implement news API
- [x] Publish to npm
- [x] Continuous testing using Travis CI
- [ ] Return `result_data` in methods
- [ ] Write full API documentation using `jsdoc`

## Authors

* Adel Qalieh

## License

[MIT Licensed](LICENSE)
