#! /usr/bin/lua

require("LuaXml")
geo = require("geocalcs")
dateparse = require("dateparse")


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

function create_wpts(name, pts, value, unit)
   local wpts = xml.new('gpx')
   wpts.version = '1.1'
   wpts.creator = arg[0]
   
   local n = xml.new('name')
   n[#n+1] = name
   wpts:append(n)
   
   for _, tp in ipairs(pts) do
      local wp = xml.new('wpt')
      wp.lat = math.deg(tp.lat)
      wp.lon = math.deg(tp.lon)
      local desc = xml.new('name')
      desc[#desc+1] = tp[value] .. ' ' .. unit
      wp:append(desc)
      wpts:append(wp)
   end
   
   return wpts
end


function calculate_points(name, trkseg, t_interval, d_interval)
   local tp1 = {}
   local tp2 = {}
   local i = 1
   local total_d = 0
   local partial_d = 0
   local rounded_d = d_interval
   local total_t = 0
   local partial_t = 0
   local rounded_t = t_interval
   local t_points = {}
   local d_points = {}
   
   for trkpt in trkseg:nodes("trkpt") do
      --print(trkpt)
      if i == 1 then
         tp1.lat = math.rad(trkpt.lat)
         tp1.lon = math.rad(trkpt.lon)
         tp1.time = dateparse.parse(trkpt:find("time")[1])
         
         local tp3 = {}
         tp3.lat, tp3.lon = tp1.lat, tp1.lon
         tp3.time = 0
         tp3.distance = 0
         d_points[#d_points+1] = tp3
         
      else
         local tp2 = {}
         tp2.lat = math.rad(trkpt.lat)
         tp2.lon = math.rad(trkpt.lon)
         tp2.time = dateparse.parse(trkpt:find("time")[1])
      
         if tp2.time ~= tp1.time then
            local delta_t = tp2.time - tp1.time
            local delta_d = geo.distance_between(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
            local bearing = geo.bearing(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
            local speed = delta_d / delta_t
            
            while rounded_d >= total_d and rounded_d < total_d + delta_d do
               -- Rounded point is this far along this segment
               partial_d = rounded_d - total_d
               local tp3 = {}
               tp3.lat, tp3.lon = geo.destination(tp1.lat, tp1.lon, partial_d, bearing, geo.spheroid)
               tp3.trktime = 0
               tp3.time = 0
               tp3.distance = rounded_d
               d_points[#d_points+1] = tp3
--               print(tp2.time, tp1.lat, tp1.lon, partial_d, bearing, tp3.lat, tp3.lon, rounded_d)
               rounded_d = rounded_d + d_interval
            end

            while rounded_t >= total_t and rounded_t < total_t + delta_t do
               partial_t = rounded_t - total_t
               local partial_d = partial_t * speed
               local tp4 = {}
               tp4.lat, tp4.lon = geo.destination(tp1.lat, tp1.lon, partial_d, bearing, geo.spheroid)
               tp4.trktime = rounded_t
               tp4.time = tp1.time + partial_t
               tp4.distance = 0
               t_points[#t_points+1] = tp4
               rounded_t = rounded_t + t_interval
            end
            
--            print(tp2.time, total_t, delta_t, total_d, delta_d, math.deg(bearing))

            total_d = total_d + delta_d
            total_t = total_t + delta_t
         end
         
         tp1 = tp2
      end
      i = i + 1
   end
   
   local d_wpts = create_wpts(name, d_points, 'distance', 'm')
   local t_wpts = create_wpts(name, t_points, 'trktime', 's')
   local h_wpts = create_wpts(name, t_points, 'time', 's')
   return t_wpts, d_wpts, h_wpts
end



filename = arg[1]
distance = arg[2]
time = arg[3]

file=xml.load(filename)
gpx = file:find("gpx")


for trk in gpx:nodes("trk") do
   trk.name = trk:find("name")[1]
   for trkseg in trk:nodes("trkseg") do
      t_points, d_points, h_points = calculate_points(trk.name, trkseg, tonumber(time), tonumber(distance))
   end
   d_points:save(trk.name .. '-' .. distance .. 'm.gpx')
   t_points:save(trk.name .. '-' .. time .. 's-rel.gpx')
   h_points:save(trk.name .. '-' .. time .. 's-abs.gpx')
end

