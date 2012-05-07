#! /usr/bin/lua

local M = {}

local function parseargs(s)
  local arg = {}
  string.gsub(s, "([%w:]+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end
    
local TAG = 0

function M.collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {[TAG]=label})
      xargs = parseargs(xarg)
      for k, v in pairs(xargs) do
         top[k] = v
      end
    elseif c == "" then   -- start tag
      top = {[TAG]=label}
      xargs = parseargs(xarg)
      for k, v in pairs(xargs) do
         top[k] = v
      end
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose[TAG] ~= label then
        error("trying to close "..toclose[TAG].." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack][TAG])
  end
  return stack[1]
end

return M

