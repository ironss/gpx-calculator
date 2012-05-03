#! /usr/bin/lua

require("LuaXml")

file=xml.load(arg[1])
gpx = file:find("gpx")

-- Iterator for searching for nodes with a specific tag
function xml.nodes(t, tag)
   local i = 0
   local f = function()
      local n
      repeat
         i = i + 1
         n = t[i]
      until (n == nil or n:find(tag) ~= nil)
      
      return n
   end
   
   return f
end


for trk in gpx:nodes("trk") do
   trk.name = trk:find("name")
   for trkseg in trk:nodes("trkseg") do

      local tp1 = {}
      local i = 1
      for trkpt in trkseg:nodes("trkpt") do
         if i == 1 then
            tp1.lat = trkpt.lat
            tp1.lon = trkpt.lon
            tp1.time = trkpt:find("time")[1]
         else
            local tp2 = {}
            tp2.lat = trkpt.lat
            tp2.lon = trkpt.lon
            tp2.time = trkpt:find("time")[1]
         
            if tp2.time ~= tp1.time then
               -- Do calculations
               print(tp2.time, tp1.time, tp2.lat, tp2.lon)
            end
            
            tp1 = tp2
         end
         i = i + 1
      end
   end
end


