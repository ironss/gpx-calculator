#! /usr/bin/lua

require("LuaXml")


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

function haversin(theta)
   local theta2 = theta / 2
   local sin_theta2 = math.sin(theta2)
   return sin_theta2 * sin_theta2
end

function distance_between(lat1, lon1, lat2, lon2, sph)
   local d = sph.r * 2 * math.asin(math.sqrt(haversin(lat2 - lat1) + math.cos(lat1) * math.cos(lat2) * haversin(lon2 - lon1)))
   return d
end

function bearing(lat1, lon1, lat2, lon2, sph)
   local dlon = lon2 - lon1
   local y = math.sin(dlon) * math.cos(lat2)
   local x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dlon)
   local bearing = math.atan2(y, x)
   return math.fmod(bearing + 2*math.pi, 2*math.pi)
end


function rad_from_deg(deg)
   return deg * math.pi / 180
end

function deg_from_rad(rad)
   return rad * 180 / math.pi
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
         tp1.lat = rad_from_deg(trkpt.lat)
         tp1.lon = rad_from_deg(trkpt.lon)
         tp1.time = time_from_iso8601_str(trkpt:find("time")[1])
      else
         local tp2 = {}
         tp2.lat = rad_from_deg(trkpt.lat)
         tp2.lon = rad_from_deg(trkpt.lon)
         tp2.time = time_from_iso8601_str(trkpt:find("time")[1])
      
         if tp2.time ~= tp1.time then
            local delta_t = tp2.time - tp1.time
            local delta_d = distance_between(tp1.lat, tp1.lon, tp2.lat, tp2.lon, spheroid)
            local bearing = bearing(tp1.lat, tp1.lon, tp2.lat, tp2.lon, spheroid)
            
            if rounded_d >= total_d and rounded_d < total_d + delta_d then
               -- Rounded point is this far along this segment
               partial_d = rounded_d - total_d
               print(tp2.time, "*", "*", partial_d, rounded_d)
               rounded_d = rounded_d + d_interval
            end
            print(tp2.time, total_t, delta_t, total_t + delta_t, total_d, delta_d, deg_from_rad(bearing))

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


