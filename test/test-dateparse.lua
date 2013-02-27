#! /usr/bin/lua

dateparse = require("dateparse")
parsedate = dateparse.parse

r = require("test/dateparse-tests")
os.exit(r)

