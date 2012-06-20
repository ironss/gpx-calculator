#! /usr/bin/lua

local xml = require("xml")
local dateparse = require("dateparse")
local geo = require("geocalcs")

local M = {}

if xml.nodes == nil then
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
end

function M.load(filename)
   local xmldata = xml.load(filename)
   local gpxdata = xml.find(xmldata, "gpx")

   local gpx = {}

   do
      local node = gpxdata:find("name")
      if node ~= nil then
         gpx.name = node[1]
      else
         gpx.name = filename
      end
   end
      
   local waypoints = {}
   local tracks = {}
   local routes = {}
   
   for trk in gpxdata:nodes("trk") do
      track = {}
      do
         local node = trk:find("name")
         if node ~= nil then
            track.name = node[1]
         else
            track.name = gpx.name
         end
      end
      
      for trkseg in trk:nodes("trkseg") do
         for trkpt in trkseg:nodes("trkpt") do
            local tp = {}
            tp.lat = math.rad(trkpt.lat)
            tp.lon = math.rad(trkpt.lon)
            tp.time = dateparse.parse(trkpt:find("time")[1], 'yyyy-mm-ddwHH:MM:SS[.ssss]w')
            
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


local function default_format_name(tp)
   local s = table.concat{os.date('!%H:%MZ', tp.time), 
                                   ' (', 
--                                   os.date('!+%H:%M', tp.trktime), ', ',
--                                   math.floor(tp.distance + 0.5), 'm, ',
                                   string.format("%3.1f kn", tp.speed * 1.94384),
                                   ')' }
   return s
end

local function default_format_desc(tp)
   local s = table.concat{os.date('!%H:%M:%SZ', tp.time), 
                                   ' (', 
                                   os.date('!+%H:%M:%S', tp.trktime), ', ',
                                   math.floor(tp.distance + 0.5), 'm, ',
                                   string.format("%3.1f kn", tp.speed * 1.94384),
                                   ')' }
   return s
end

function M.append_wpts(parent, pts, format_name, format_desc)
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
      
      local desc = xml.new('desc')
      desc[#desc+1] = format_desc(tp)
      wp:append(desc)
      
      wpts:append(wp)
   end
   
   return wpts
end


function M.append_trk(parent, name, points)

end


return M

