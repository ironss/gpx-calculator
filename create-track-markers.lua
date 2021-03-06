#! /usr/bin/lua

gpx = require('gpx')
geo = require('geocalcs')

filename = arg[1]
time = tonumber(arg[2])
distance = tonumber(arg[3])

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
   if time ~= nil then 
      local filename = trk.name .. '-' .. time .. 's.gpx'
      print(filename)
      local t_points = geo.calculate_t_points(trk, time)
      local t_gpx = gpx.create_wpts(trk.name, t_points)
      gpx.save(filename, t_gpx)
   end

   if distance ~= nil then
      local filename = trk.name .. '-' .. distance .. 'm.gpx'
      print(filename)
      local d_points = geo.calculate_d_points(trk, distance)
      local d_gpx = gpx.create_wpts(trk.name, d_points)
      gpx.save(filename, d_gpx)
   end
end

