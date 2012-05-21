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
   tb.synctime = function()
      local t1
      local t2
      
      t1 = gettime()
      repeat
         t2 = gettime()
      until t2 ~= t1
      
      return t2
   end
   
   return tb
end



-- Define 'timebase_posix' if posix library is available.

local e, posix = pcall(require, 'posix')
if e and posix.clock_gettime then
   local function posix_gettime()
      local s, f = posix.clock_gettime("")
      local t = s + f / 1000000000
      return math.floor(t / 0.0001) * 0.0001
   end
   timebase_posix = timebase_new('clock_posix', 0.0001, posix_gettime)
end

local function os_gettime()
   return os.time()
end
timebase_os = timebase_new('clock_os', 1, os_gettime)





local function measure_new(name, f, tb, accuracy, n_min)
   local m = {}
   
   m.name = name
   m.tb = tb
   m.f = f
   m.accuracy = accuracy
   m.n_min = n_min

   local function reset()
      m.t_min = 1E15
      m.t_max = 0
      m.t_total = 0
      m.n = 0
   end
   
   local function measure()
   end
   
   local function calibrate(accuracy)
      if accuracy == 0 or accuracy == nil then
         accuracy = 0.00001
      end

      m.calibration_accuracy = 0
      m.null_calibration.ave = 0
      m.gettime_calibration.ave = 0

      m.null_calibration = measure(function() end, accuracy, 1, clock)
      m.gettime_calibration = measure(clock.gettime, accuracy, 1, clock)
      m.calibration_accuracy = accuracy
   end

   reset()
   
   m.reset = reset
   m.calibrate = calibrate
   m.measure = measure
   
   return m
end


M.null_calibration = { }
M.gettime_calibration = { }
M.calibration_accuracy = 1

local function measure(f, accuracy, n_min, clock)
   if accuracy == 0 or type(accuracy) ~= 'number' then
      accuracy = M.calibration_accuracy * 10
   end
   
   local clock = clock or timebase_posix
   local clock_resolution = clock.resolution
   local clock_synctime = clock.synctime
   local clock_gettime = clock.gettime
   
   local t_max = 1/accuracy * clock_resolution
   local n_max = 1/accuracy
   local ending = t_max * n_max

   local n_min = n_min or 1
   
   if accuracy / 10 < M.calibration_accuracy then
      M.calibrate(accuracy / 10)
   end

   local min = math.min
   local max = math.max
   local n = 0
   local tm_total = 0
   local tm_min = 1000000
   local tm_max = 0
   local tm_ave = 0

   local t_0
   local t_1
   local t_2

   repeat
      if type(f_setup) == 'function' then f_setup() end
      t_1 = clock_gettime()
      f()
      t_2 = clock_gettime()
      if type(f_teardown) == 'function' then t_teardown() end
      
      local t_diff = t_2 - t_1
      tm_total = tm_total + t_diff -- - M.null_calibration.t_ave
      tm_min = min(tm_min, t_diff)
      tm_max = max(tm_max, t_diff)
      
      n = n+1
      --print(tm_total, n)
   until accuracy * tm_total >= clock_resolution * 1.1
   
   tm_ave = (tm_total / n) - M.null_calibration.t_ave
   --print(tm_total, n, (1-((tm_total - clock_resolution) / tm_total))*100)
 
   return { t_total=tm_total, n=n, t_ave=tm_ave, t_min=tm_min, t_max=tm_max }
end


local function calibrate(accuracy, clock)
   if accuracy == 0 or accuracy == nil then
      accuracy = 0.0001
   end
   
   local clock = clock or timebase_posix
   print(clock.name)

   M.calibration_accuracy = 0
   M.null_calibration.t_ave = 0
   M.gettime_calibration.t_ave = 0

   M.null_calibration = measure(function() end, accuracy, 5, clock)
   M.gettime_calibration = measure(clock.gettime, accuracy, 5, clock)
   M.calibration_accuracy = accuracy
end


M.clock_resolution = clock_resolution
M.gettime = gettime
M.measure =  measure
M.calibrate = calibrate

return M

