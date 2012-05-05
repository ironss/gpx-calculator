#! /usr/bin/lua

gpx = require('gpx')
geo = require('geocalcs')


filename = arg[1]
distance = arg[2]
time = arg[3]

waypoints, tracks, routes = gpx.load(filename)

for _, trk in ipairs(tracks) do
   for i = 1, #trk - 1 do
      tp1 = trk[i]
      tp2 = trk[i+1]
      tp1.distance = geo.distance_between(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
      tp1.bearing = geo.bearing(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
      tp1.duration = tp2.time - tp1.time
      tp1.speed = tp1.distance / tp1.duration
   end
end


for _, trk in ipairs(tracks) do
   print(trk.name)
   local d_points = geo.calculate_d_points(trk, tonumber(distance))
   local d_gpx = gpx.append_wpts(name, d_points, 'distance', 'm')
   d_gpx:save(trk.name .. '-' .. distance .. 'm.gpx')
 
   local t_points = geo.calculate_t_points(trk, tonumber(time))
   local t_gpx = gpx.append_wpts(name, t_points, 'trktime', 's')
   t_gpx:save(trk.name .. '-' .. time .. 's.gpx')
end

