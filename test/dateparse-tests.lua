#! /usr/bin/lua


require("luaunit")

Test_dateparse = {}

function Test_dateparse:test_date_only()
   assertEquals(parsedate('2012')         , 1325329200)
   assertEquals(parsedate('201204')       , 1333191600)
   assertEquals(parsedate('20120421')     , 1334923200)
   assertEquals(parsedate('2012-04-21')   , 1334923200)
   assertEquals(parsedate('21 April 2012'), 1334923200)
--   assertEquals(parsedate('April 2012')   , 1333191600)
end

function Test_dateparse:test_combined()
   assertEquals(parsedate('2012-04-21T01:02:03'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03'), 1334926923)
end

function Test_dateparse:test_fractional_second()
   assertEquals(parsedate('20120421010203.0'), 1334926923)
--   assertEquals(parsedate('20120421010203.5'), 1334926923.5)
   assertEquals(parsedate('2012-04-21T01:02:03.0'), 1334926923)
   assertEquals(parsedate('2012-04-21T01:02:03.00'), 1334926923)
   assertEquals(parsedate('2012-04-21T01:02:03.000'), 1334926923)
   assertEquals(parsedate('2012-04-21T01:02:03.0000'), 1334926923)
end

function Test_dateparse:test_timezone_military()
   assertEquals(parsedate('2012-04-21T01:02:03Z'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03Z'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03M'), 1334926923)
end

function Test_dateparse:test_timezone_nz()
   assertEquals(parsedate('2012-04-21T01:02:03NZST'), 1334926923)
   assertEquals(parsedate('2012-04-21 01:02:03NZDT'), 1334926923)
end

function Test_dateparse:test_timezone_offset()
   --assertEquals(parsedate('2012-04-21T01:02:03+12'), 1334926923)
   assertEquals(parsedate('2012-04-21T01:02:03+1200'), 1334926923)
   assertEquals(parsedate('2012-04-21T01:02:03+12:00'), 1334926923)
end

return LuaUnit:run()

