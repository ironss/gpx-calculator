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

      local i = 1
      tp1 = {}
      tp2 = {}
      for trkpt in trkseg:nodes("trkpt") do
         if i == 1 then
            tp1.lat = trkpt.lat
            tp1.lon = trkpt.lon
            tp1.time = trkpt:find("time")[1]
         else
            tp2.lat = trkpt.lat
            tp2.lon = trkpt.lon
            tp2.time = trkpt:find("time")[1]
         
            -- Do calculations
            print(tp2.time, tp2.time - tp1.time, tp2.lat, tp2.lon)
            
            tp1 = tp2
         end
      end
   end
end



t = gpx_trackpoints(gpx)
for i = 2, #t do 
   tp = t[i]
   print(i, tp.time, tp.lat, tp.lon)
end

