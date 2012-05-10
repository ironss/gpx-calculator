#! /usr/bin/lua

local M = {}

M.spheroid = {}
M.spheroid.a = 6378100  -- axis


local sin = math.sin
local cos = math.cos
local asin = math.asin
local atan2 = math.atan2


function M.haversin(theta)
   local theta2 = theta / 2
   local sin_theta2 = sin(theta2)
   return sin_theta2 * sin_theta2
end

-- Functions to compute the following
-- * distance between two points (lat1, lon1) and (lat2, lon2)
-- * initial bearing of second point (lat2, lon2) from first point (lat1, lon2)
-- * position of second point (lat2, lon2) a given distance and bearing from first point (lat1, lon1)
--
-- Thanks to http://www.movable-type.co.uk/scripts/latlong.html for the Javascript that these
-- functions were based on.


function M.distance_between(lat1, lon1, lat2, lon2, geoid)
   local d = geoid.a * 2 * asin(math.sqrt(M.haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * M.haversin(lon2 - lon1)))
   return d
end


function M.bearing(lat1, lon1, lat2, lon2, geoid)
   local dlon = lon2 - lon1
   local y = sin(dlon) * cos(lat2)
   local x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon)
   local bearing = atan2(y, x)
   return math.fmod(bearing + 2*math.pi, 2*math.pi)
end


function M.destination(lat1, lon1, distance, bearing, geoid)
   local lat2 = asin(sin(lat1) * cos(distance / geoid.a) + cos(lat1) * sin(distance / geoid.a) * cos(bearing))
   local lon2 = lon1 + atan2(sin(bearing) * sin(distance / geoid.a) * cos(lat1), cos(distance / geoid.a) - sin(lat1) * sin(lat2))
   return lat2, lon2
end


-- Given a set of track points, calculate points at fixed distances along the track.

function M.calculate_d_points(trk, d_interval)
   local tp1 = {}
   local tp2 = {}
   local total_d = 0
   local partial_d = 0
   local rounded_d = 0
   local d_points = {}
   local total_t = 0
   local partial_t = 0
   
   for i = 1, #trk - 1 do
      tp1 = trk[i]
      tp2 = trk[i+1]
      
      while rounded_d <= total_d + tp1.distance do
         partial_d = rounded_d - total_d
         partial_t = partial_d / tp1.speed

         local tp3 = {}
         tp3.lat, tp3.lon = geo.destination(tp1.lat, tp1.lon, partial_d, tp1.bearing, geo.spheroid)
         tp3.time = tp1.time + partial_t
         tp3.trktime = total_t + partial_t
         tp3.distance = rounded_d
         tp3.speed = tp1.distance / tp1.duration
         
         d_points[#d_points+1] = tp3

         rounded_d = rounded_d + d_interval
      end
      
      total_d = total_d + tp1.distance
      total_t = total_t + tp1.duration
   end

   return d_points
end


-- Given a set of track points, calculate a set of points at fixed times along the track.
-- If start time is omitted or zero, then the points are relative to the start of the track.
-- If the start time is calculated from the time of the first trackBy specifying the start time correctly, it is possible to ensure that the times
-- 
function M.calculate_t_points(trk, t_interval, start_time)
   local tp1 = {}
   local tp2 = {}
   local total_t = 0
   local partial_t = 0
   local rounded_t = start_time or t_interval - math.fmod(trk[1].time, t_interval)
   local total_d = 0
   local partial_d = 0
   local t_points = {}
   
   for i = 1, #trk - 1 do
      tp1 = trk[i]
      tp2 = trk[i+1]
      
      while rounded_t <= total_t + tp1.duration do
         partial_t = rounded_t - total_t
         partial_d = tp1.speed * partial_t

         local tp3 = {}
         tp3.lat, tp3.lon = geo.destination(tp1.lat, tp1.lon, partial_d, tp1.bearing, geo.spheroid)
         tp3.time = tp1.time + partial_t
         tp3.trktime = total_t + partial_t
         tp3.distance = total_d + partial_d
         tp3.speed = tp1.distance / tp1.duration
         
         t_points[#t_points+1] = tp3

         rounded_t = rounded_t + t_interval
      end
      
      total_t = total_t + tp1.duration
      total_d = total_d + tp1.distance
   end

   return t_points
end

return M

