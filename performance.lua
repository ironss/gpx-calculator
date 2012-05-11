#! /usr/bin/lua

-- Measure performance of a function by calling it repeatedly.
-- Reduce the effect of the management overhead by
-- timing an increasing number of iterations


local M = {}

local clock_gettime
local clock_resolution

local posix = require 'posix'
if posix and posix.clock_gettime_ then
   clock_resolution = 0.01

   -- gettime
   -- Returns monotonic increasing time as decimal seconds.
   -- Resolution depends on underlying POSIX library, 
   --   could be 10ms, or 1us or even 1ns

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

local function measure(f, accuracy)
   if accuracy == 0 or accuracy == nil then
      accuracy = 0.01
   end
   local max_t = 1/accuracy * clock_resolution
   local max_n = 1/accuracy
   print(accuracy, max_n, max_t)
   
   local t_total
   local n
   
   if M.null_calibration == nil and M.null_calibration.ave == nil then
      M.calibrate()
   end


   if clock_resolution > 0.2 then
      local t_1
      local t_2

      n = 0
      local t_1 = clock_synctime()
      repeat
         f()
         t_2 = clock_gettime()
         n = n+1
      until t_2 > t_1 + max_t or (n > max_n and t_2 > t_1)
      t_total = t_2 - t_1
   else
      
   end
   
   return { t_total=t_total, n=n, ave=(t_total / n) - M.null_calibration.ave }
end


local function calibrate(n)
   M.null_calibration.ave = 0
   M.null_calibration = measure(function() end)
   M.gettime_calibration = measure(clock_gettime)
end


M.clock_resolution = clock_resolution
M.gettime = gettime
M.measure =  measure
M.calibrate = calibrate

return M

