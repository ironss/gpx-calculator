#! /usr/bin/lua

require('luaunit')

xml = require("xml")

Test_xml_tostring  = {}


function Test_xml_tostring:test_empty()
   local t1 = { [0]='test' }
   local actual = xml.tostring(t1)
   assertEquals(actual, '<test />\n')
end

function Test_xml_tostring:test_empty_with_attributes()
   local t1 = { [0]='test', name='Name', desc='Description' }
   local actual = xml.tostring(t1)
   assertEquals(actual, '<test name="Name" desc="Description" />\n')
end

function Test_xml_tostring:test_with_string_data()
   local t1 = { [0]='test', 'Test data 1' }
   local actual = xml.tostring(t1)
   assertEquals(actual, '<test>Test data 1</test>\n')
end

function Test_xml_tostring:test_with_nested_data()
   local t1 = { [0]='test' }
   local t2 = { [0]='nest' }
   t1[1] = t2
   local actual = xml.tostring(t1)
   assertEquals(actual, [[
<test>
  <nest />
</test>
]])
end

function Test_xml_tostring:test_with_all()
   local t1 = { [0]='test' }
   local t2 = { [0]='nest' }
   local t3 = { [0]='more', name='Name' }
   t1[1] = t2
   t1[2] = "Test data"
   t1[3] = "More data"
   t1[4] = t3
   t1[5] = "Still more"
   local actual = xml.tostring(t1)
   assertEquals(actual, [[
<test>
  <nest />
  Test data 
  More data 
  <more name="Name" />
  Still more 
</test>
]])
end


Test_xml = {}

function Test_xml:test_new_string()
   local x1 = xml.new('test')
   assertEquals(xml.tostring(x1), '<test />\n')
end

function Test_xml:test_append_string()
   local x1 = xml.new('test')
   xml.append(x1, 'Test data')
   assertEquals(xml.tostring(x1), '<test>Test data</test>\n')
end

function Test_xml:test_append_nested()
   local x1 = xml.new('test')
   local x2 = xml.new('nest')
   xml.append(x1, x2)
   assertEquals(xml.tostring(x1), [[
<test>
  <nest />
</test>
]])
end


LuaUnit:run()

