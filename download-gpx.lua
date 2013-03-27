#! /usr/bin/lua

local posix = require('posix')
local xml = require("pl.xml")

local out_path = './tracks/'

local function process_gpx_files(fn, device_id)
   local xmldata = xml.parse(fn, true)
   local gpxdata = xmldata
   
   for _2, trk in ipairs(gpxdata:get_elements_with_name("trk")) do
      for _3, trkseg in ipairs(trk:get_elements_with_name("trkseg")) do
         local trkpt = trkseg:child_with_name('trkpt')
         if trkpt ~= nil then
            local time = trkpt:child_with_name('time')
            if time ~= nil then
               local time_text = time:get_text()
         --      print(time_text)
               local time_text = string.sub(time_text, 1, 19)
               local time_text = string.gsub(time_text, '-', '')
               local time_text = string.gsub(time_text, 'T', '_')
               local time_text = string.gsub(time_text, ':', '')
         --      print(time_text)
               local trk_name = time_text .. '-' .. device_id 

               local name = xml.new('name')
               name[#name+1] = trk_name
               trk:add_direct_child(name)

               local xout = xml.new('gpx')
            	xout.attr.creator = arg[0]
            	xout.attr.version = '1.1'

               local n = xml.new('name')
               n[#n+1] = trk_name
               xout:add_child(n)
               
               local t = xml.new('trk')
               t:add_direct_child(trkseg)
               t:add_child(n)
               xout:add_child(t)
	
               local filename = out_path .. trk_name .. '.gpx'
               print('   --> ' .. filename)
               local file = io.open(filename, "w")
               file:write("<?xml version=\"1.0\"?>\n<!-- file \"",filename, "\", generated by script " .. arg[0] .. " -->\n")
               file:write(xml.tostring(xout, '', '  '))
               file:close()
            end
         end
      end
   end
end

local function archive_files(out_path, device_id)
--   os.execute('git add ' .. out_path .. '*.gpx 2> /dev/null')
--   os.execute('git commit ' .. out_path .. ' -m "Added tracks from ' .. device_id .. '." 2> /dev/null')
--   os.execute('git push 2> /dev/null')
end

local function process_bt747(device)
   if not posix.exists(device.path) then
      return
   end

   local device_type = device.model
   local device_uid = device.uid
   local device_id

   print('Identifying device...')
   local cmd = [[/opt/BT747/run_j2se-batch.sh -p ]] .. device.path .. [[ --device=HOLUX245 --mac-address | sed -n -e 's/Bluetooth Mac Addr://p' | sed -e 's/:/./g' ]]
   local f = io.popen(cmd)
   device_uid = f:read('*l')
   device_id = device_type .. '-' .. device_uid
   print('Identifying device...' .. device_id)
   
   local tmp_path = './tmp/' .. device_id
   posix.mkdir(tmp_path, '-p')

   local cmd = [[/opt/BT747/run_j2se-batch.sh -p ]] .. device.path .. [[ --device=HOLUX245 -a -f ]] .. tmp_path .. [[/]] .. device_id .. [[ --timesplit=60 --splittype=TRACK --outtype=GPX >/dev/null 2>/dev/null ]]
   os.execute(cmd)
   os.execute('rm -f ' .. device_id .. '.bin')
   
   local gpx_files = posix.ls(tmp_path .. '/*.gpx', '-1')
   for _1, fn in ipairs(gpx_files) do
      process_gpx_files(fn, device_id)
   end
   posix.rm(tmp_path, '-rf')

   archive_files(out_path, device_id)
end


local function process_gpsbabel(device)
   local device_type = device.model
   local device_uid = device.uid
   local device_id = device_type .. '-' .. device_uid
   print('Identifying device...' .. device_id)
   
   local tmp_path = './tmp/' .. device_id
   posix.mkdir(tmp_path, '-p')

   local cmd = [[ /usr/bin/gpsbabel -t -i garmin -f ]] .. device.path .. [[ -o gpx -F ]] .. tmp_path .. [[/]] .. device_id .. [[.gpx >/dev/null 2>/dev/null ]]
   print(cmd)
   os.execute(cmd)
   
   local gpx_files = posix.ls(tmp_path .. '/*.gpx', '-1')
   for _1, fn in ipairs(gpx_files) do
      process_gpx_files(fn, device_id)
   end
   posix.rm(tmp_path, '-rf')

   archive_files(out_path, device_id)
end


local function process_gpx(device, app)
   local app_name = app.name
   local device_type = device.model
   local device_uid = device.uid
   local device_id = device_type .. '-' .. device_uid .. '-' .. app_name
   print('Identifying device...' .. device_id)

   local mount_path = device.path .. app.path
   local tmp_path = './tmp/' .. device_id

   posix.mkdir(tmp_path, '-p')
   posix.cp(mount_path .. '*.gpx', tmp_path)

   local gpx_files = posix.ls(tmp_path .. '/*.gpx', '-1')
   for _1, fn in ipairs(gpx_files) do
      process_gpx_files(fn, device_id)
   end
   posix.rm(tmp_path, '-rf')

   archive_files(out_path, device_id)
end


local apps = 
{
   { name='mxmariner', path='mxmariner/gpx/'      , process=process_gpx },
   { name='oruxmaps' , path='oruxmaps/tracklogs/' , process=process_gpx },
}

local function process_filesystem(device)
   for _, app in pairs(apps) do
      if posix.exists(device.path) then
         app.process(device, app)
      end
   end
end


local devices = 
{
   { model='vf845'      , uid='78.1D.BA.13.07.C1', path='/media/FFB8-0F12/', process=process_filesystem },
   { model='ideos_x3'   , uid='10.C6.1F.56.EC.45', path='/media/7E4A-0FF3/', process=process_filesystem },
   { model='holux_1000c', uid=nil                , path='/dev/ttyACM0'     , process=process_bt747      },
   { model='garmin_72h',  uid='382.1055.173'     , path='usb:'             , process=process_gpsbabel   },
}


for _, device in pairs(devices) do
   print(device.model)
   device.process(device)
end

