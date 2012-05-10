#! /usr/bin/lua

local M = {}


local function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs(tt) do
      if type(key) ~= 'number' or (type(key) == 'number' and key <= 0) then
         table.insert(sb, string.rep (" ", indent)) -- indent it

         if type(key) == 'string' then
            table.insert(sb, string.format('["%s"] = ', tostring(key)))
         elseif type(key) == 'number' then
            table.insert(sb, string.format('[%s] = ', tonumber(key)))
         else
            table.insert('[(' .. type(key) .. '?)] = ')
         end
         
         if type(value) == "table" and not done[value] then
           done[value] = true
           table.insert(sb, "{\n");
           table.insert(sb, table_print (value, indent + 2, done))
           table.insert(sb, string.rep (" ", indent)) -- indent it
           table.insert(sb, "},\n");
         elseif type(value) == 'string' then
           table.insert(sb, string.format("\"%s\",\n", tostring(value)))
         elseif type(value) == 'number' then
           table.insert(sb, string.format("%s,\n", tostring(value)))
         else
           table.insert(sb, '(' .. type(value) .. '?),')
         end
       end
    end

    for key, value in ipairs (tt) do
         table.insert(sb, string.rep (" ", indent)) -- indent it

         if type(value) == "table" and not done[value] then
           done[value] = true
           table.insert(sb, "{\n");
           table.insert(sb, table_print (value, indent + 2, done))
           table.insert(sb, string.rep (" ", indent)) -- indent it
           table.insert(sb, "},\n");
         elseif type(value) == 'string' then
           table.insert(sb, string.format("\"%s\",\n", tostring(value)))
         elseif type(value) == 'number' then
           table.insert(sb, string.format("%s,\n", tostring(value)))
         else
           table.insert(sb, '?(' .. type(key) .. ')=(' .. type(value) .. ')?,')
         end
    end

    return table.concat(sb)
  else
    return tt .. "\n"
  end
end


function M.tostring(tbl)
    if type(tbl) == "nil" then
        return tostring(nil)
    elseif type(tbl) == "table" then
        return table_print(tbl)
    elseif type(tbl) == "string" then
        return tbl
    else
        return tostring(tbl)
    end
end

return M

