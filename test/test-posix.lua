#! /usr/bin/lua

posix = require("posix")

require("luaunit")

Test_posix = {}

function Test_posix:test_exists()
   assertEquals(posix.exists(arg[0]), true)
   assertEquals(posix.exists('asdf'), false)
end

function Test_posix:test_mkdir()
   local f = 'test/testdir'
   os.execute('rm -rf ' .. f)
   assertEquals(posix.exists(f), false)
   posix.mkdir(f)
   assertEquals(posix.exists(f), true)
   os.execute('rm -rf ' .. f)
end   

LuaUnit:run()

