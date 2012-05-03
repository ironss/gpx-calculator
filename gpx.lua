#! /usr/bin/lua

require("LuaXml")
geo = require("geocalcs")

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


function calculate_points(trkseg, t_interval, d_interval)
   local tp1 = {}
   local i = 1
   local total_d = 0
   local partial_d = 0
   local rounded_d = d_interval
   local total_t = 0
   local partial_t = 0
   
   for trkpt in trkseg:nodes("trkpt") do
      if i == 1 then
         tp1.lat = geo.rad_from_deg(trkpt.lat)
         tp1.lon = geo.rad_from_deg(trkpt.lon)
         tp1.time = time_from_iso8601_str(trkpt:find("time")[1])
      else
         local tp2 = {}
         tp2.lat = geo.rad_from_deg(trkpt.lat)
         tp2.lon = geo.rad_from_deg(trkpt.lon)
         tp2.time = time_from_iso8601_str(trkpt:find("time")[1])
      
         if tp2.time ~= tp1.time then
            local delta_t = tp2.time - tp1.time
            local delta_d = geo.distance_between(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
            local bearing = geo.bearing(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
            
            if rounded_d >= total_d and rounded_d < total_d + delta_d then
               -- Rounded point is this far along this segment
               partial_d = rounded_d - total_d
               print(tp2.time, "*", "*", partial_d, rounded_d)
               rounded_d = rounded_d + d_interval
            end
            print(tp2.time, total_t, delta_t, total_t + delta_t, total_d, delta_d, geo.deg_from_rad(bearing))

            total_d = total_d + delta_d
            total_t = total_t + delta_t
         end
         
         tp1 = tp2
      end
      i = i + 1
   end
end



file=xml.load(arg[1])
gpx = file:find("gpx")

for trk in gpx:nodes("trk") do
   trk.name = trk:find("name")
   for trkseg in trk:nodes("trkseg") do
      t_points, d_points = calculate_points(trkseg, 60, 200)
   end
end


