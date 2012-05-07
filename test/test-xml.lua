#! /usr/bin/lua

xml = require("xml")

f = io.open('test/2012-04-30-0830-mxmariner.gpx')
x = f:read('*all')
--print(x)
xdata = xml.collect(x)



t = require('table-tostring')
print(t.to_string(xdata))

