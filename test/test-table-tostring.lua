#! /usr/bin/lua

require('luaunit')

t = require('table-tostring')

Test_table_tostring  = {}

function Test_table_tostring:test_empty()
   local t1 = {}
   assertEquals(t.tostring(t1), '')
end

function Test_table_tostring:test_array_1_string()
   local t1 = { 'test' }
   assertEquals(t.tostring(t1), '"test",\n')
end

function Test_table_tostring:test_array_1_number()
   local t1 = { 123 }
   assertEquals(t.tostring(t1), '123,\n')
end

function Test_table_tostring:test_array_2()
   local t1 = { 'test1', 234 }
   assertEquals(t.tostring(t1), '"test1",\n234,\n')
end

function Test_table_tostring:test_hash_1_string()
   local t1 = { hash1='Hash1' }
   assertEquals(t.tostring(t1), '["hash1"] = "Hash1",\n')
end

function Test_table_tostring:test_hash_1_number()
   local t1 = { hash1=123 }
   assertEquals(t.tostring(t1), '["hash1"] = 123,\n')
end

--[[
function Test_table_tostring:test_hash_2()
   local t1 = { hash1=123, hash2='hash2' }
   assertEquals(t.tostring(t1), '["hash1"] = 123,\n')
end
]]

function Test_table_tostring:test_combined()
   local t1 = { 123, 234, hash1='Hash1', 345, 456 }
   assertEquals(t.tostring(t1), '["hash1"] = "Hash1",\n123,\n234,\n345,\n456,\n')
end

function Test_table_tostring:test_nested()
   local t1 = { 123, { 12, 23, nest1='Nest1', }, 234, hash1='Hash1', 'string3' }
   assertEquals(t.tostring(t1), [[
["hash1"] = "Hash1",
123,
{
  ["nest1"] = "Nest1",
  12,
  23,
},
234,
"string3",
]]) 
end


LuaUnit:run()
