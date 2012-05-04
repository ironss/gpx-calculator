#! /usr/bin/lua

local M = {}

M.spheroid = {}
M.spheroid.a = 6378100  -- axis
M.spheroid.f = 1        -- flattening
M.spheroid.r = 0        -- reciprocal flattening


local sin = math.sin
local cos = math.cos
local asin = math.asin
local atan2 = math.atan2


function M.haversin(theta)
   local theta2 = theta / 2
   local sin_theta2 = sin(theta2)
   return sin_theta2 * sin_theta2
end


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


function M.rad_from_deg(deg)
   return deg * math.pi / 180
end

function M.deg_from_rad(rad)
   return rad * 180 / math.pi
end

return M

