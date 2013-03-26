#! /usr/bin/lua

local app_name = 'mxmariner'
local device_type = 'vf845'
local device_uid = 'FFB8-0F12'
local device_id = app_name .. '-' .. device_type .. '-' .. device_uid

local mount_path = '/media/FFB8-0F12/mxmariner/gpx/'
local tmp_path = './tmp/'

local posix = require('posix')

posix.mkdir(tmp_path)
posix.cp(mount_path .. '*.gpx', tmp_path)
gpx_files = posix.ls(tmp_path .. '*.gpx')


for _, fn in ipairs(gpx_files) do
   print(fn)
end
