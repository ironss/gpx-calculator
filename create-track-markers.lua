#! /usr/bin/lua

gpx = require('gpx')

filename = arg[1]
distance = arg[2]
time = arg[3]

file=gpx.load(filename)
gpxdata = file:find("gpx")


for trk in gpxdata:nodes("trk") do
   trk.name = trk:find("name")[1]
   for trkseg in trk:nodes("trkseg") do
      t_points, d_points, h_points = gpx.calculate_points(trk.name, trkseg, tonumber(time), tonumber(distance))
   end
   d_points:save(trk.name .. '-' .. distance .. 'm.gpx')
   t_points:save(trk.name .. '-' .. time .. 's-rel.gpx')
   h_points:save(trk.name .. '-' .. time .. 's-abs.gpx')
end

