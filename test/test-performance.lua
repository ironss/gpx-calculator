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
      m.calibrate(accuracy / 5)
      local r = m.measure()
--      print(m.calibration.n, m.calibration.t_min, m.calibration.t_ave, m.calibration.t_max)
--      print(r.n, r.t_min, r.t_ave, r.t_max)
      assert_close(r.t_ave - m.calibration.t_ave, duration, r.t_ave * accuracy)
   end
end

LuaUnit:run()

