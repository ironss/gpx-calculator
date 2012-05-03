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


function gpx_trackpoints(gpx)
   local t = {}
   for trk in gpx:nodes("trk") do
      trk.name = trk:find("name")
      
      for trkseg in trk:nodes("trkseg") do
         for trkpt in trkseg:nodes("trkpt") do
            tp = {}
            tp.lat = trkpt.lat
            tp.lon = trkpt.lon
            tp.time = trkpt:find("time")[1]
            t[#t+1] = tp
         end
      end
   end
   return t
end



t = gpx_trackpoints(gpx)
for i = 2, #t do 
   tp = t[i]
   print(i, tp.time, tp.lat, tp.lon)
end

