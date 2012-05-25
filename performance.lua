#! /usr/bin/lua

-- Measure performance of a function by calling it repeatedly.
-- Reduce the effect of the management overhead by
-- timing an increasing number of iterations


local M = {}


-- Timebases

local function timebase_new(name, resolution, gettime)
   local tb = {}
   
   tb.name = name
   tb.resolution = resolution
   tb.gettime = gettime
   
   return tb
end


-- Define 'timebase_posix' if posix library is available.

local e, posix = pcall(require, 'posix')
if e and posix.clock_gettime then
   local function posix_gettime()
      local s, f = posix.clock_gettime("")
      local t = s + f / 1000000000
      return t
   end
   M.timebase_posix = timebase_new('clock_posix', 0.0001, posix_gettime)
end


local function os_gettime()
   return os.time()
end
M.timebase_os = timebase_new('clock_os', 1, os_gettime)


local function measure_new(name, f, timebase, accuracy, f_setup, f_teardown)
   local m = {}
   
   m.name = name
   m.timebase = timebase
   m.accuracy = accuracy
   m.calibration_accuracy = 100
   m.results = {}
   m.results.f = f or function() end
   m.results.f_setup = f_setup
   m.results.f_teardown = f_teardown

   local function reset(results)
      results.n = 0
      results.t_min = 1E15
      results.t_max = 0
      results.t_sum = 0
      results.t_sum2 = 0
   end
   
   local calibrate
   
   local function measure(results, n_max, f)
      local results = results or m.results
      local f = f or results.f
      local n_max = n_max or 1/m.accuracy * 10
      local t_max = 1/m.accuracy * m.timebase.resolution
      
      if m.calibration_accuracy > m.accuracy / 10 then
         calibrate(m.accuracy / 10)
      end

      local clock_gettime = m.timebase.gettime
      local t_1
      local t_2

      repeat
         if type(results.f_setup) == 'function' then results.f_setup() end
         t_1 = clock_gettime()
         f()
         t_2 = clock_gettime()
         if type(results.f_teardown) == 'function' then results.f_teardown() end
         
         local t_diff = t_2 - t_1 -- - m.t_overhead
         
         results.n = results.n + 1
         results.t_sum = results.t_sum + t_diff
         results.t_sum2 = results.t_sum2 + t_diff * t_diff
         results.t_min = math.min(results.t_min, t_diff)
         results.t_max = math.max(results.t_max, t_diff)
         
         --print(results.n, results.t_sum)
      until m.accuracy * results.t_sum >= m.timebase.resolution --or results.n > n_max -- * 1.1
      
      results.t_ave = (results.t_sum / results.n) -- - M.null_calibration.t_ave
      --print(tm_total, n, (1-((tm_total - clock_resolution) / tm_total))*100)
    
      return results
   end
   
   function calibrate(accuracy)
      if accuracy == 0 or accuracy == nil then
         accuracy = m.accuracy / 10
      end

      m.calibration_accuracy = 0
      m.calibration = {}
      m.calibration.f = function() end

      reset(m.calibration)
      measure(m.calibration)

      m.calibration_accuracy = accuracy
   end

   reset(m.results)
   
   m.reset = reset
   m.calibrate = calibrate
   m.measure = measure
   
   return m
end

M.timebase_new = timebase_new
M.measure_new = measure_new

return M

