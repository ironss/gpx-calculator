#! /usr/bin/lua

xml = require("xml")
local dateparse = require("dateparse")
local geo = require("geocalcs")

local M = {}

function M.load(filename)
   local xmldata = xml.load(filename)
   local t = require('table-tostring')
   print(t.to_string(xmldata))
   local gpxdata = xml.find(xmldata, "gpx")

   local waypoints = {}
   local tracks = {}
   local routes = {}
   
   for trk in xml.nodes(gpxdata, "trk") do
      track = {}
      track.name = xml.find(trk, "name")[1]
      
      for trkseg in xml.nodes(trk, "trkseg") do
         for trkpt in xml.nodes(trkseg, "trkpt") do
            local tp = {}
            tp.lat = math.rad(trkpt.lat)
            tp.lon = math.rad(trkpt.lon)
            tp.time = dateparse.parse(xml.find(trkpt, "time")[1])
            
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
   xml.append(wpts, n)
   
   for _, tp in ipairs(pts) do
      local wp = xml.new('wpt')
      wp.lat = math.deg(tp.lat)
      wp.lon = math.deg(tp.lon)
      
      local name = xml.new('name')
      name[#name+1] = tp[value] .. ' ' .. unit
--      wp:append(name)
      
      local desc = xml.new('name')
      desc[#desc+1] = table.concat{os.date('!%H:%M:%SZ', tp.time), 
                                   ' (', 
                                   os.date('!+%H:%M:%S', tp.trktime), ', ',
                                   math.floor(tp.distance + 0.5), 'm)'}
      xml.append(wp, desc)
      
      xml.append(wpts, wp)
   end
   
   return wpts
end



function M.append_trk(parent, name, points)

end


return M

