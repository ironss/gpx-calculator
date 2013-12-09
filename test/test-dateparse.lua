#! /usr/bin/lua

dateparse = require("dateparse")
parsedate = dateparse.parse

result = require("test/dateparse-tests")
os.exit(result)

