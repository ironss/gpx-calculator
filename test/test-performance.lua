#! /usr/bin/lua


p = require('performance')

require("luaunit")

tests = 
{
   { '100us_10pc' , 0.0001, 0.1    },
--   { '100us_1pc'  , 0.0001, 0.01   },
   { '200us_10pc' , 0.0002, 0.1    },
--   { '200us_1pc'  , 0.0002, 0.01   },
   { '500us_10pc' , 0.0005, 0.1    },
--   { '500us_1pc'  , 0.0005, 0.01   },
   { '1ms_10pc'   , 0.0010, 0.1    },
--   { '1ms_1pc'    , 0.0010, 0.01   },
   { '2ms_10pc'   , 0.0020, 0.1    },
--   { '2ms_1pc'    , 0.0020, 0.01   },
   { '5ms_10pc'   , 0.0050, 0.1    },
--   { '5ms_1pc'    , 0.0050, 0.01   },
   { '10ms_10pc'  , 0.0100, 0.1    },
   { '10ms_1pc'   , 0.0100, 0.01   },
--   { '10ms_0_1pc' , 0.0100, 0.001  },
   { '20ms_10pc'  , 0.0200, 0.1    },
   { '20ms_1pc'   , 0.0200, 0.01   },
   { '20ms_0_1pc' , 0.0200, 0.001  },
   { '50ms_10pc'  , 0.0500, 0.1    },
   { '50ms_1pc'   , 0.0500, 0.01   },
   { '50ms_0_1pc' , 0.0500, 0.001  },
   { '100ms_10pc' , 0.1000, 0.1    },
   { '100ms_1pc'  , 0.1000, 0.01   },
   { '100ms_0_1pc', 0.1000, 0.001  },
   { '200ms_10pc' , 0.2000, 0.1    },
   { '200ms_1pc'  , 0.2000, 0.01   },
   { '200ms_0_1pc', 0.2000, 0.001  },
   { '500ms_10pc' , 0.5000, 0.1    },
   { '500ms_1pc'  , 0.5000, 0.01   },
   { '500ms_0_1pc', 0.5000, 0.001  },
   { '1s_10pc'    , 1.0000, 0.1    },
   { '1s_1pc'     , 1.0000, 0.01   },
   { '1s_0_1pc'   , 1.0000, 0.001  },
   { '1s_0_01pc'  , 1.0000, 0.0001 },
   { '2s_10pc'    , 2.0000, 0.1    },
   { '2s_1pc'     , 2.0000, 0.01   },
   { '2s_0_1pc'   , 2.0000, 0.001  },
   { '2s_0_01pc'  , 2.0000, 0.0001 },
}


require 'posix'

function clock_gettime()
   local s, f = posix.clock_gettime("")
   local t = s + f / 1000000000
   return t
end

function busy_loop(t)
   local t_1
   local t_2
   t_1 = clock_gettime()
   repeat
      t_2 = clock_gettime()
   until t_2 > t_1 + t
end



Test_performance = {}

for _, t in ipairs(tests) do
   local name = t[1]
   local duration = t[2]
   local accuracy = t[3]
   Test_performance['test_' .. name] = function(t)
      local m = p.measure_new(name, function() busy_loop(duration) end, p.timebase_posix, accuracy)
      local r = m.measure()
      print(m.calibration.n, m.calibration.t_min, m.calibration.t_ave, m.calibration.t_max)
      print(r.n, r.t_min, r.t_ave, r.t_max)
      assert_close(r.t_min, duration, r.t_ave * accuracy)
   end
end

Test_performance = nil


timebase_test = p.timebase_new('test', 1, function() return timebase_test.t end)
timebase_test.t = 0

function timebase_test.settime(t) 
   timebase_test.t = t 
end

function timebase_test.inctime(n)
   local n = n or 1
   local t = n * timebase_test.resolution
   timebase_test.t = timebase_test.t + t
end

function timebase_test.gettime()
   timebase_test.inctime()
   return timebase_test.t
end


Test_timebase = {}

function Test_timebase:test_1()
   local t_1 = timebase_test.gettime()
   local t_2 = timebase_test.gettime()
   assertEquals(t_2, t_1 + 1)
end

function Test_timebase:test_2() 
   local m = p.measure_new('test', function() end, timebase_test, 0.01, nil, nil)
   local r = m.measure()
   assertEquals(r.n, 100)
   assertEquals(r.t_sum, 100)
   assertEquals(r.t_sum2, 100)
   assertEquals(r.t_min, 1)
   assertEquals(r.t_ave, 1)
   assertEquals(r.t_max, 1)
end


function Test_timebase:test_3() 
   local m = p.measure_new('test', function() timebase_test.inctime() end, timebase_test, 0.01, nil, nil)
   local r = m.measure()
   assertEquals(r.n, 50)
   assertEquals(r.t_sum, 100)
   assertEquals(r.t_sum2, 200)
   assertEquals(r.t_min, 2)
   assertEquals(r.t_ave, 2)
   assertEquals(r.t_max, 2)
end


function Test_timebase:test_4() 
   local m = p.measure_new('test', function() timebase_test.inctime(4) end, timebase_test, 0.01, nil, nil)
   local r = m.measure()
   assertEquals(r.n, 20)
   assertEquals(r.t_sum, 100)
   assertEquals(r.t_sum2, 500)
   assertEquals(r.t_min, 5)
   assertEquals(r.t_ave, 5)
   assertEquals(r.t_max, 5)
end


function Test_timebase:test_5()
   local count = 0
   local m = p.measure_new('test', function() 
                                      count = count+1
                                      if math.mod(count, 2) == 0 then
                                         timebase_test.inctime() 
                                      end
                                   end, timebase_test, 0.01, nil, nil)
   local r = m.measure()
   assertEquals(r.n, 67)
   assertEquals(r.t_sum, 100)
   assertEquals(r.t_sum2, 166)
   assertEquals(r.t_min, 1)
   assertClose(r.t_ave, 1.4925, 0.001)
   assertEquals(r.t_max, 2)
end


function Test_timebase:test_6() 
   local count = 0
   local m = p.measure_new('test', function() 
                                      count = count+1
                                      if math.mod(count, 5) == 0 then
                                         timebase_test.inctime(3) 
                                      end
                                   end, timebase_test, 0.01, nil, nil)
   timebase_test.count = 0
   local r = m.measure()
   assertEquals(r.n, 64)
   assertEquals(r.t_sum, 100)
   assertEquals(r.t_sum2, 244)
   assertEquals(r.t_min, 1)
   assertClose(r.t_ave, 1.5625, 0.001)
   assertEquals(r.t_max, 4)
end


function Test_timebase:test_7() 
   local m = p.measure_new('test', function() timebase_test.inctime(98) end, timebase_test, 0.01, nil, nil)
   local r = m.measure()
   assertEquals(r.n, 2)
   assertEquals(r.t_sum, 198)
   assertEquals(r.t_sum2, 19602)
   assertEquals(r.t_min, 99)
   assertEquals(r.t_ave, 99)
   assertEquals(r.t_max, 99)
end


function Test_timebase:test_8() 
   local m = p.measure_new('test', function() timebase_test.inctime(100) end, timebase_test, 0.01, nil, nil)
   local r = m.measure()
   assertEquals(r.n, 1)
   assertEquals(r.t_sum, 101)
   assertEquals(r.t_sum2, 10201)
   assertEquals(r.t_min, 101)
   assertEquals(r.t_ave, 101)
   assertEquals(r.t_max, 101)
end



LuaUnit:run()

