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


function default_format_name(tp)
   local s = table.concat{os.date('!%H:%MZ', tp.time), 
                                   ' (', 
--                                   os.date('!+%H:%M', tp.trktime), ', ',
--                                   math.floor(tp.distance + 0.5), 'm, ',
                                   string.format("%3.1f kn", tp.speed * 1.94384),
                                   ')' }
   return s
end

function default_format_desc(tp)
   local s = table.concat{os.date('!%H:%M:%SZ', tp.time), 
                                   ' (', 
                                   os.date('!+%H:%M:%S', tp.trktime), ', ',
                                   math.floor(tp.distance + 0.5), 'm, ',
                                   string.format("%3.1f kn", tp.speed * 1.94384),
                                   ')' }
   return s
end


function M.append_wpts(parent, pts, format)
   local format_name = format_name or default_format_name
   local format_desc = format_desc or default_format_desc

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
      name[#name+1] = format_name(tp)
      wp:append(name)
      
      local desc = xml.new('name')
      desc[#desc+1] = format_desc(tp)
      wp:append(desc)
      
      wpts:append(wp)
   end
   
   return wpts
end


function M.append_trk(parent, name, points)

end


return M

