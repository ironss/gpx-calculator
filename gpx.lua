#! /usr/bin/lua

require("LuaXml")
dateparse = require("dateparse")
geo = require("geocalcs")

local M = {}

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

function M.load(filename)
   local file = xml.load(filename)
   local gpxdata = file:find("gpx")

   local waypoints = {}
   local tracks = {}
   local routes = {}
   
   for trk in gpxdata:nodes("trk") do
      track = {}
      track.name = trk:find("name")[1]
      
      for trkseg in trk:nodes("trkseg") do
         for trkpt in trkseg:nodes("trkpt") do
            local tp = {}
            tp.lat = math.rad(trkpt.lat)
            tp.lon = math.rad(trkpt.lon)
            tp.time = dateparse.parse(trkpt:find("time")[1])
            
            if #track == 0 or tp.time ~= track[#track].time then
               track[#track+1] = tp
            end
         end
      end
      tracks[#tracks+1] = track
   end

   return waypoints, tracks, routes
end


function M.create_gpx(name)
end

function M.append_wpts(parent, pts, value, unit)
   local wpts = xml.new('gpx')
   wpts.version = '1.1'
   wpts.creator = arg[0]
   
   local n = xml.new('name')
   n[#n+1] = parent
   wpts:append(n)
   
   for _, tp in ipairs(pts) do
      local wp = xml.new('wpt')
      wp.lat = math.deg(tp.lat)
      wp.lon = math.deg(tp.lon)
      
      local name = xml.new('name')
      name[#name+1] = tp[value] .. ' ' .. unit
--      wp:append(name)
      
      local desc = xml.new('name')
      desc[#desc+1] = table.concat{os.date('%H:%M:%S', tp.time), 
                                   ' (', 
                                   os.date('%H:%M:%S', tp.trktime - 12*60*60), ', ',
                                   math.floor(tp.trktime + 0.5) , ', ',
                                   math.floor(tp.distance + 0.5), 'm)'}
      wp:append(desc)
      
      wpts:append(wp)
   end
   
   return wpts
end


function M.append_trk(parent, name, points)

end


return M

