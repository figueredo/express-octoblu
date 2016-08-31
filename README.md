# express-octoblu

Express with common Octoblu middlewares

[![Build Status](https://travis-ci.org/octoblu/.svg?branch=master)](https://travis-ci.org/octoblu/)
[![Code Climate](https://codeclimate.com/github/octoblu//badges/gpa.svg)](https://codeclimate.com/github/octoblu/)
[![Test Coverage](https://codeclimate.com/github/octoblu//badges/coverage.svg)](https://codeclimate.com/github/octoblu/)
[![npm version](https://badge.fury.io/js/.svg)](http://badge.fury.io/js/)
[![Gitter](https://badges.gitter.im/octoblu/help.svg)](https://gitter.im/octoblu/help)

# Table of Contents

* [Introduction](#introduction)
* [Getting Started](#getting-started)
  * [Install](#install)
* [Usage](#usage)
* [Bundled Packages](#bundled-packages)
* [Bundled Middlewares](#bundled-middlewares)
* [License](#license)

# Introduction

Express bundled with common Octoblu middlewares. It also handles `uncaughtExceptions` using raven.

# Getting Started

## Install

```bash
npm install --save express-octoblu
```

# Usage

## options

All options are optional and have default values.

**disableLogging** - defaults to `false`
**disableCors** - defaults to `false`
**logFn** - defaults to `console.error`
**bodyLimit** - defaults to `1mb`
**faviconPath** - defaults to the bundled octoblu favicon.ico.
**octobluRaven** - defaults to `new OctobluRaven()`

```coffee
octobluExpress = require 'express-octoblu'

app = octobluExpress()

# ...
# app specific middlewares
# ...

app.listen PORT, =>
  # ...

```


# Bundled Packages

* [express](https://github.com/expressjs/express)
* [octoblu-raven](https://github.com/octoblu/node-octoblu-raven)

# Bundled Middlewares

* [express-meshblu-healthcheck](https://github.com/octoblu/express-meshblu-healthcheck)
* [express-package-version](https://github.com/rjz/express-package-version)
* [compression](https://github.com/expressjs/compression)
* [morgan](https://github.com/expressjs/morgan)
* [body-parser](https://github.com/expressjs/body-parser)
* [serve-favicon](https://github.com/expressjs/serve-favicon)
* [cors](https://github.com/expressjs/cors)

## License

The MIT License (MIT)

Copyright (c) 2016 Octoblu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

