#! /usr/bin/lua

folder=arg[0]:match('(.*)/.+$')
package.path = package.path .. ';'..folder..'/?.lua'

gpx = require('gpx')
geo = require('geocalcs')

filename = arg[1]
time = tonumber(arg[2])
timefilename = arg[3]

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
      local filename = timefilename or trk.name .. '-' .. time .. 's.gpx'
--      print(filename)
      local t_points = geo.calculate_t_points(trk, time)
      
--      local tmpfilename = os.tmpname()
--      local f=io.open(filename, 'w')
--      for _, tp in ipairs(t_points) do
--         f:write(math.deg(tp.lon), '\t', math.deg(tp.lat), '\n')
--      end
--      f:close()
      local t_gpx = gpx.create_wpts(trk.name, t_points)
      gpx.save(filename, t_gpx)
   end
end

