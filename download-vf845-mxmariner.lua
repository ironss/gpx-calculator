#! /usr/bin/lua

local devices = 
{
   { model='vf845',    uid='78.1D.BA.13.07.C1', path='/media/FFB8-0F12/' },
--   { model='ideos_x3', uid='asdfasdfasdfasdfs', path='/junk/' },
}


local posix = require('posix')
local xml = require("pl.xml")

local function process_mxmariner(device)
   local app_name = 'mxmariner'
   local device_type = device.model
   local device_uid = device.uid
   local device_id = app_name .. '-' .. device_type .. '-' .. device_uid

   local mount_path = device.path .. 'mxmariner/gpx/'
   local tmp_path = './tmp/'
   local out_path = './tracks/'

   posix.mkdir(tmp_path, '-p')
   posix.cp(mount_path .. '*.gpx', tmp_path)
   gpx_files = posix.ls(tmp_path .. '*.gpx', '-1')

   for _1, fn in ipairs(gpx_files) do
      print(fn)
      local xmldata = xml.parse(fn, true)
      local gpxdata = xmldata
      
      for _2, trk in ipairs(gpxdata:get_elements_with_name("trk")) do
         local trkseg = trk:child_with_name('trkseg')
         local trkpt = trkseg:child_with_name('trkpt')
         local time = trkpt:child_with_name('time')
         local time_text = time:get_text()
   --      print(time_text)
         local time_text = string.sub(time_text, 1, 19)
         local time_text = string.gsub(time_text, '-', '')
         local time_text = string.gsub(time_text, 'T', '_')
         local time_text = string.gsub(time_text, ':', '')
   --      print(time_text)
         local trk_name = device_id .. '-' .. time_text
         print(trk_name)
         
         
         local name = xml.new('name')
         name[#name+1] = trk_name
         trk:add_direct_child(name)

         local xout = xml.new('gpx')
      	xout.attr.creator = arg[0]
      	xout.attr.version = '1.1'
      
	      local n = xml.new('name')
	      n[#n+1] = trk_name
	      xout:add_child(n)
         xout:add_child(trk)
		
		   local filename = out_path .. trk_name .. '.gpx'
         local file = io.open(filename, "w")
         file:write("<?xml version=\"1.0\"?>\n<!-- file \"",filename, "\", generated by script " .. arg[0] .. " -->\n")
         file:write(xml.tostring(xout, '', '  '))
         file:close()

      end
   end
end

process_mxmariner(devices[1])

--posix.rm(tmp_path, '-rf')

--os.execute('git add ' .. out_path .. '*.gpx 2> /dev/null')
--os.execute('git commit ' .. out_path .. ' -m "Added tracks from ' .. device_id .. '." 2> /dev/null')
--os.execute('git push 2> /dev/null')

