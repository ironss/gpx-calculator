#! /usr/bin/lua

local xml = require("pl.xml")
local dateparse = require("dateparse")
local geo = require("geocalcs")

local M = {}

function M.load(filename)
   local f = io.open(filename)
   local xdata = f:read('*all')
   local xmldata = xml.parse(xdata)
   local gpxdata = xmldata --:get_elements_with_name("gpx")

   local waypoints = {}
   local tracks = {}
   local routes = {}
   
   for _, trk in ipairs(gpxdata:get_elements_with_name("trk")) do
      track = {}
      track.name = trk:child_with_name("name")[1]
      for _, trkseg in ipairs(trk:get_elements_with_name("trkseg")) do
         for _, trkpt in ipairs(trkseg:get_elements_with_name("trkpt")) do
            local tp = {}
            tp.lat = math.rad(trkpt.attr.lat)
            tp.lon = math.rad(trkpt.attr.lon)
            tp.time = dateparse.parse(trkpt:child_with_name("time")[1])
            
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


function M.append_wpts(parent, pts, format_name, format_desc)
   local format_name = format_name or default_format_name
   local format_desc = format_desc or default_format_desc

   local wpts = xml.new('gpx')
   wpts.attr.creator = arg[0]
   wpts.attr.version = '1.1'
   
   local n = xml.new('name')
   n[#n+1] = parent
   wpts:add_child(n)
   
   for _, tp in ipairs(pts) do
      local wp = xml.new('wpt')
      wp.attr.lat = math.deg(tp.lat)
      wp.attr.lon = math.deg(tp.lon)
      
      local name = xml.new('name')
      name[#name+1] = format_name(tp)
      wp:add_child(name)
      
      local desc = xml.new('desc')
      desc[#desc+1] = format_desc(tp)
      wp:add_child(desc)
      
      wpts:add_child(wp)
   end
   
   return wpts
end


function M.append_trk(parent, name, points)

end

function M.save(data, filename)
  if not data then return end
  if not filename or #filename==0 then return end
  local file = io.open(filename, "w")
  print(filename)
  file:write("<?xml version=\"1.0\"?>\n<!-- file \"",filename, "\", generated by script -->\n")
  file:write(xml.tostring(data, '', '  '))
  file:close()
end

return M

