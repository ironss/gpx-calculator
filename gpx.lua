#! /usr/bin/lua

require("LuaXml")

file=xml.load("/home/ironss/Dropbox/sailing/gpx/test/2012-04-30-0830-holux-opencpn.gpx")
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



for n in nodes(gpx, "trk") do
   trk = n:find("trk")
   trk.name = trk:find("name")
   print(trk.name)
   
   for n in nodes(trk, "trkseg") do
      trkseg = n:find("trkseg")
      if trkseg ~= nil then
         for n in nodes(trkseg, "trkpt") do
            trkpt = n:find("trkpt")
            trkpt.time = trkpt:find("time")
            print(trkpt.time)
         end
      end
   end
end


