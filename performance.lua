#! /usr/bin/lua

-- Measure performance of a function by calling it repeatedly.
-- Reduce the effect of the management overhead by
-- timing an increasing number of iterations


local M = {}

local clock_gettime
local clock_resolution

local posix = require 'posix'
if posix and posix.clock_gettime then
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

local function measure(f, accuracy)
   if accuracy == 0 or accuracy == nil then
      accuracy = 0.0001
   end
   local max_t = 1/accuracy * clock_resolution
   local max_n = 1/accuracy
   
   if accuracy < M.calibration_accuracy then
      M.calibrate(accuracy)
   end

   local t_total
   local n

   local t_1
   local t_2

   n = 0
   local t_1 = clock_synctime()
   repeat
      f()
      t_2 = clock_gettime()
      n = n+1
   until (t_2 >= t_1 + max_t) or (n >= max_n and t_2 >= t_1 + clock_resolution)
   t_total = t_2 - t_1
 
   return { t_total=t_total, n=n, t_ave=(t_total / n) }
end


local function calibrate(n, accuracy)
   if accuracy == 0 or accuracy == nil then
      accuracy = 0.00001
   end

   M.null_calibration.ave = 0
   M.gettime_calibration.ave = 0
   M.calibration_accuracy = accuracy
   M.null_calibration = measure(function() end, accuracy)
   M.gettime_calibration = measure(clock_gettime, accuracy)
end

M.clock_resolution = clock_resolution
M.gettime = gettime
M.measure =  measure
M.calibrate = calibrate

return M

