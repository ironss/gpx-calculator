#! /usr/bin/lua

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



require("luaunit")

Test_dateparse = {}

function Test_dateparse:test_date_only()
   assertEquals(parsedate('2012')      , 1325329200)
   assertEquals(parsedate('201204')    , 1333191600)
   assertEquals(parsedate('20120421')  , 1334923200)
   assertEquals(parsedate('2012-04-21'), 1334923200)
end

function Test_dateparse:test_combined()
   assertEquals(parsedate('2012-04-21T01:02:03'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03'), 1334926923)
end

function Test_dateparse:test_timezone_military()
   assertEquals(parsedate('2012-04-21T01:02:03Z'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03Z'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03M'), 1334926923)
end

function Test_dateparse:test_timezone_nz()
   assertEquals(parsedate('2012-04-21 01:02:03NZST'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03NZDT'), 1334926923)
end

function Test_dateparse:test_timezone_offset()
   assertEquals(parsedate('2012-04-21 01:02:03+12'), 1334926923)
end

LuaUnit:run()

