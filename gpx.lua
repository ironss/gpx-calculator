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


spheroid = {}
spheroid.r = 6378100

function haversine(theta)
   return math.sin(theta / 2) ^ 2
end

function f(lat1, lon1, lat2, lon2, sph)
   local d = sph.r * 2 * math.asin(math.sqrt(haversine(lat2 - lat1) + math.cos(lat1) * math.cos(lat2) * haversine(lon2 - lon1)))
   return d
end


function rad_from_deg(deg)
   return deg * 2 * math.pi / 360
end


function timetable(year, month, day, hour, min, sec)
   local t = {}
   t.year = year
   t.month = month
   t.day = day
   t.hour = hour
   t.min = min
   t.sec = sec
   return t
end

function time_from_iso8601_str(str)
   local tt = timetable(string.match(str, "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z"))
   local t = os.time(tt)
   return t
end



function do_calculations(tp1, tp2)
   local distance = f(tp2.lat, tp2.lon, tp1.lat, tp1.lon, spheroid)
   print(tp2.time, tp2.time - tp1.time, distance)
end


for trk in gpx:nodes("trk") do
   trk.name = trk:find("name")
   for trkseg in trk:nodes("trkseg") do

      local tp1 = {}
      local i = 1
      for trkpt in trkseg:nodes("trkpt") do
         if i == 1 then
            tp1.lat = rad_from_deg(trkpt.lat)
            tp1.lon = rad_from_deg(trkpt.lon)
            tp1.time = time_from_iso8601_str(trkpt:find("time")[1])
         else
            local tp2 = {}
            tp2.lat = rad_from_deg(trkpt.lat)
            tp2.lon = rad_from_deg(trkpt.lon)
            tp2.time = time_from_iso8601_str(trkpt:find("time")[1])
         
            if tp2.time ~= tp1.time then
               do_calculations(tp1, tp2)
            end
            
            tp1 = tp2
         end
         i = i + 1
      end
   end
end


