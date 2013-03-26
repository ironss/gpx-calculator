
local M = {}

M.mkdir = function(path, p)
   local cmd = 'mkdir ' .. p .. ' ' .. path
   cmd = cmd .. '>/dev/null 2>/dev/null'
   local r = os.execute(cmd)
end

M.cp = function(src, dest)
   local cmd = 'cp ' .. src .. ' ' .. dest
   cmd = cmd .. '>/dev/null 2>/dev/null'
   local r = os.execute(cmd)
end

M.ls = function(path)
   local cmd = 'ls -1 ' .. path
   cmd = cmd .. ' 2>/dev/null'
   local f = io.popen(cmd)
   local r = {}
   repeat
      l = f:read('*l')
      r[#r+1] = l
      --print(l)
   until l == nil

   return r
end

M.rm = function(path, p)
   local cmd = 'rm ' .. p .. ' ' .. path
   cmd = cmd .. '>/dev/null 2>/dev/null'
   local r = os.execute(cmd)
end

M.exists = function(path)
   return true
end

return M

