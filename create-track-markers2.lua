#! /usr/bin/lua

gpx = require('gpx2')
geo = require('geocalcs')
xml = require('xml')

filename = arg[1]
distance = tonumber(arg[2])
time = tonumber(arg[3])

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
   local d_points = geo.calculate_d_points(trk, distance)
   local d_gpx = gpx.append_wpts(trk.name, d_points)
--   d_gpx:save(trk.name .. '-' .. distance .. 'm-rel-2.gpx')
 
   local t_points = geo.calculate_t_points(trk, time)
   local t_gpx = gpx.append_wpts(trk.name, t_points)
--   t_gpx:save(trk.name .. '-' .. time .. 's-rel-2.gpx')
   
   local h_points = geo.calculate_t_points(trk, time, true)
   local h_gpx = gpx.append_wpts(trk.name, h_points)
   h_gpx:save(trk.name .. '-' .. time .. 's-2.gpx')
end

