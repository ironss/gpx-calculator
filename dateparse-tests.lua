#! /usr/bin/lua

dateparse = require("interfaceware-dateparse")
--dateparse = require("interfaceware-dateparse")

local tests = 
{
   -- Date only
   { "2012"      , 1325329200 },
   { "201204"    , 1333191600 },
--   { "2012-04"   , 1333191600 },
   { "20120421"  , 1334923200 },
   { "2012-04-21", 1334923200 },
   
   -- Time only
--   { "T01:02:03", 1334926923 },
   
   
   -- Combined date and time
   { "2012-04-21T01:02:03", 1334926923 },
   { "2012-04-21 01:02:03", 1334926923 },
--   { "20120421T010203", 1334926923 },
--   { "20120421 010203", 1334926923 },
   
   -- Complete, with timezone
   { "2012-04-21T01:02:03Z", 1334926923 },
   { "2012-04-21 01:02:03Z", 1334926923 },

   { "2012-04-21 01:02:03M", 1334926923 },

   { "2012-04-21T01:02:03NZDT", 1334926923 },

--   { "2012-04-21T01:02:03+06:00", 1334926923 },
}

local str
local actual
local expected

for _, v in ipairs(tests) do
   str = v[1]
   expected = v[2]
   actual = dateparse.parse(str)
   
   if expected ~= actual then
      print(str .. ": expected " .. expected .. ", actual: " .. actual)
   end
end
