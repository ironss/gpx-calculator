#! /usr/bin/lua

local M = {}

M.spheroid = {}
M.spheroid.a = 6378100  -- axis
M.spheroid.f = 1        -- flattening
M.spheroid.r = 0        -- reciprocal flattening


function M.haversin(theta)
   local theta2 = theta / 2
   local sin_theta2 = math.sin(theta2)
   return sin_theta2 * sin_theta2
end

function M.distance_between(lat1, lon1, lat2, lon2, geoid)
   local d = geoid.a * 2 * math.asin(math.sqrt(M.haversin(lat2 - lat1) + math.cos(lat1) * math.cos(lat2) * M.haversin(lon2 - lon1)))
   return d
end

function M.bearing(lat1, lon1, lat2, lon2, geoid)
   local dlon = lon2 - lon1
   local y = math.sin(dlon) * math.cos(lat2)
   local x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dlon)
   local bearing = math.atan2(y, x)
   return math.fmod(bearing + 2*math.pi, 2*math.pi)
end


function M.rad_from_deg(deg)
   return deg * math.pi / 180
end

function M.deg_from_rad(rad)
   return rad * 180 / math.pi
end

return M

