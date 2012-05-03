#! /usr/bin/lua

require("LuaXml")

file=xml.load(arg[1])
gpx = file:find("gpx")

function nodes(t, name)
   local i = 0
   local f = function()
      local n
      repeat
         i = i + 1
         n = t[i]
--         print("                                                   ", name, i, n)
      until (n == nil or n:find(name) ~= nil)
      
      return n
   end
   
   return f
end


for trk in nodes(gpx, "trk") do
   trk.name = trk:find("name")
   print(trk.name)
   
   for trkseg in nodes(trk, "trkseg") do
      for trkpt in nodes(trkseg, "trkpt") do
         trkpt.time = trkpt:find("time")[1]
         print(trkpt.time, trkpt.lat, trkpt.lon)
      end
   end
end

