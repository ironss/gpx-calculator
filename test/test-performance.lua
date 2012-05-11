#! /usr/bin/lua

p = require('performance')

print('Calibrating...')

p.calibrate()
print('Resolution: ', p.clock_resolution)
print('null() overhead: ', p.null_calibration.t_ave, p.null_calibration.t_total, p.null_calibration.n)
print('gettime() overhead: ', p.gettime_calibration.t_ave, p.gettime_calibration.t_total, p.gettime_calibration.n)


tests = 
{
   { '1ms'  , 0.001 },
   { '2ms'  , 0.002 },
   { '5ms'  , 0.005 },
   { '10ms' , 0.01  },
   { '20ms' , 0.02  },
   { '50ms' , 0.05  },
   { '100ms', 0.1   },
   { '200ms', 0.2   },
   { '500ms', 0.5   },
   { '1s'   , 1     },
   { '2s'   , 2     },
   { '5s'   , 5     },
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


for _, t in ipairs(tests) do
   print(t[1])
   t.m = p.measure(function() busy_loop(t[2]) end, 0.01)
   print(t[1] .. ': ', t.m.t_total, t.m.n, t.m.t_ave)
end

