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

function Test_xml_tostring:test_with_attribute_and_string_data()
   local t1 = { [0]='test', 'Test data 1', name='Name' }
   local actual = xml.tostring(t1)
   assertEquals(actual, '<test name="Name">Test data 1</test>\n')
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
   local t4 = { [0]='again' }
   t1[1] = t2
   t1[2] = "Test data"
   t1[3] = "More data"
   t1[4] = t3
   t1[5] = "Still more"
   t1[6] = t4
   t4[1] = "Data again"
   local actual = xml.tostring(t1)
   assertEquals(actual, [[
<test>
  <nest />
  Test data 
  More data 
  <more name="Name" />
  Still more 
  <again>Data again</again>
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


local function HACK(s)
   
   local s1 = string.gsub(s, '\n(.)', '\n  %1')
   return '<table>\n  ' .. s1 .. '</table>\n'
--   return s
end

function Test_xml:test_parse_empty()
   local s1 = '<test />\n'
   local x1 = xml.parse(s1)
   assertEquals(xml.tostring(x1), HACK(s1))
end

function Test_xml:test_parse_empty_with_attribute()
   local s1 = '<test name="Name" />\n'
   local x1 = xml.parse(s1)
   assertEquals(xml.tostring(x1), HACK(s1))
end


function Test_xml:test_parse_string()
   local s1 = '<test>Test data</test>\n'
   local x1 = xml.parse(s1)
   assertEquals(xml.tostring(x1), HACK(s1))
end

function Test_xml:test_parse_string_with_attribute()
   local s1 = '<test name="Name">Test data</test>\n'
   local x1 = xml.parse(s1)
   assertEquals(xml.tostring(x1), HACK(s1))
end

function Test_xml:test_parse_nested_empty()
   local s1 = [[
<test name="Test">
  Data 
  <nest name="Nest" />
  More 
</test>
]]
   local x1 = xml.parse(s1)
   assertEquals(xml.tostring(x1), HACK(s1))

end

function Test_xml:test_parse_nested()
   local s1 = [[
<test name="Test">
  Data 
  <nest name="Nest">Nested</nest>
  More 
</test>
]]
   local x1 = xml.parse(s1)
   assertEquals(xml.tostring(x1), HACK(s1))
end

LuaUnit:run()

