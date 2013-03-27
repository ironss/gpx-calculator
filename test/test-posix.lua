#! /usr/bin/lua

posix = require("posix")

require("luaunit")

Test_posix = {}

function Test_posix:test_exists()
   local f = 'test/testfile'
   os.execute('touch ' .. f)
   assertEquals(posix.exists(f), true)
   os.execute('rm ' .. f)
   assertEquals(posix.exists(f), false)
   
   local p = 'test/testdir/'
   os.execute('mkdir -p ' .. p)
   assertEquals(posix.exists(p), true)
   os.execute('rm -f ' .. p .. '*')
   os.execute('rmdir ' .. p)
   assertEquals(posix.exists(p), false)
   
end

function Test_posix:test_rm_removes_file()
   local f = 'test/testfile'
   os.execute('touch ' .. f)
   assertEquals(posix.exists(f), true)
   posix.rm(f)
   assertEquals(posix.exists(f), false)
end

function Test_posix:test_rm_rf_removes_files_and_directories()
   local p = 'test/testdir/'
   os.execute('mkdir -p ' .. p)
   os.execute('touch ' .. p .. 'f1')
   os.execute('touch ' .. p .. 'f2')
   assertEquals(posix.exists(p), true)
   posix.rm(p, '-rf')
   assertEquals(posix.exists(p), false)
end

   
function Test_posix:test_mkdir()
   local f = 'test/testdir'
   os.execute('rm -rf ' .. f)
   assertEquals(posix.exists(f), false)
   posix.mkdir(f)
   assertEquals(posix.exists(f), true)
   os.execute('rm -rf ' .. f)
end   

function Test_posix:test_ls_empty()
   local p = 'test/testdir/'
   os.execute('mkdir -p ' .. p)
   local d = posix.ls(p)
   assertEquals(#d, 0)

   os.execute('touch ' .. p .. 'f1')
   local d = posix.ls(p)
   assertEquals(#d, 1)
   assertEquals(d[1], 'f1')
   
   os.execute('touch ' .. p .. 'f2')
   local d = posix.ls(p)
   assertEquals(#d, 2)
   assertEquals(d[1], 'f1')
   assertEquals(d[2], 'f2')

   os.execute('rm -rf ' .. p)
end

LuaUnit:run()

