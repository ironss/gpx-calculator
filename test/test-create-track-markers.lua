#! /usr/bin/lua

require('luaunit')

Test_create_markers  = {}

os.execute('rm -f test/out/*')
os.execute('mkdir -p test/out')
os.execute('./create-track-markers.lua test/track1.gpx 200 60')

--[==[
function Test_create_markers:test_distance_200m()
   local f_expected = io.open('test/ref/track1-200m.gpx')
   local f_actual = io.open('test/out/track1-200m.gpx')
   
   line_no = 0
   while true do 
      line_no = line_no + 1
      l_expected = f_expected:read('*line')
      l_actual = f_actual:read('*line')

      if l_expected == nil or l_actual == nil then break end
            
      assertEquals(line_no .. ': ' .. l_expected, line_no .. ': ' .. l_actual)
   end
end
]==]

function Test_create_markers:test_distance_60s_abs()
   local f_expected = io.open('test/ref/track1-60s.gpx')
   local f_actual = io.open('test/out/track1-60s.gpx')
   
   line_no = 0
   while true do
      line_no = line_no + 1
      l_expected = f_expected:read('*line')
      l_actual = f_actual:read('*line')

      if l_expected == nil or l_actual == nil then break end
            
      assertEquals(line_no .. ': ' .. l_expected, line_no .. ': ' .. l_actual)
   end
end


--[==[
function Test_create_markers:test_distance_60s_rel()
   local f_expected = io.open('test/ref/track1-60s-rel.gpx')
   local f_actual = io.open('test/out/track1-60s-rel.gpx')
   
   line_no = 0
   while true do
      line_no = line_no + 1
      l_expected = f_expected:read('*line')
      l_actual = f_actual:read('*line')

      if l_expected == nil or l_actual == nil then break end
            
      assertEquals(line_no .. ': ' .. l_expected, line_no .. ': ' .. l_actual)
   end
end
]==]

LuaUnit:run()

