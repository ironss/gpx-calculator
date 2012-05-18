#! /usr/bin/lua

-- Measure performance of a function by calling it repeatedly.
-- Reduce the effect of the management overhead by
-- timing an increasing number of iterations


local M = {}

local clock_gettime
local clock_resolution

local e, posix = pcall(require, 'posix')
if e and posix.clock_gettime then
   clock_resolution = 0.001  -- How can we read the resolution of the POSIX clocks?
   function clock_gettime()
      local s, f = posix.clock_gettime("")
      local t = s + f / 1000000000
      return t
   end
else
   clock_resolution = 1
   function clock_gettime()
      local t = os.time()
      return t
   end
end


function clock_synctime()
   local t1
   local t2
   
   t1 = clock_gettime()
   repeat
      t2 = clock_gettime()
   until t2 ~= t1
   return t2
end


M.null_calibration = { }
M.gettime_calibration = { }
M.calibration_accuracy = 1

local function measure(f, accuracy, n_min)
   if accuracy == 0 or type(accuracy) ~= 'number' then
      accuracy = M.calibration_accuracy * 10
   end
   local t_max = 1/accuracy * clock_resolution
   local n_max = 1/accuracy

   local n_min = n_min or 1
   
   if accuracy / 10 < M.calibration_accuracy then
      M.calibrate(accuracy / 10)
   end

   local min = math.min
   local max = math.max
   local t_total = 0
   local t_min = 1000000
   local t_max = 0
   local n = 0

   local t_0
   local t_1
   local t_2

   local t_0 = clock_synctime()
   repeat
      if type(f_setup) == 'function' then f_setup() end
      t_1 = clock_gettime()
      f()
      t_2 = clock_gettime()
      if type(f_teardown) == 'function' then t_teardown() end
      
      local t_diff = t_2 - t_1
      t_total = t_total + t_diff
      t_min = min(t_min, t_diff)
      t_max = max(t_max, t_diff)
      
      n = n+1
      --print(n, t_diff)
   until (t_2 >= t_0 + t_max and n >= n_min) or (n >= n_max and t_2 >= t_0 + clock_resolution)
 
   return { t_total=t_total, n=n, t_ave=(t_total / n), t_min=t_min, t_max=t_max }
end


local function calibrate(accuracy)
   if accuracy == 0 or accuracy == nil then
      accuracy = 0.00001
   end

   M.calibration_accuracy = 0
   M.null_calibration.ave = 0
   M.gettime_calibration.ave = 0

   M.null_calibration = measure(function() end, accuracy)
   M.gettime_calibration = measure(clock_gettime, accuracy)
   M.calibration_accuracy = accuracy
end


-- Create a new measurement clock
-- Parameters:
-- * clock, with clock.gettime(), clock.synctime and clock.resolution
-- * 

-- Returns: a table with
-- * t.measure()
-- * t.clock.resolution
-- * 
 

local function new(params)
   local t = {}
   
   t.clock = params.clock
end


M.clock_resolution = clock_resolution
M.gettime = gettime
M.measure =  measure
M.calibrate = calibrate

return M

