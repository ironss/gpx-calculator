#! /usr/bin/lua

local M = {}


local function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      if type(key) ~= 'number' or type(key) == 'number' and key <= 0 then
         table.insert(sb, string.rep (" ", indent)) -- indent it

         if type(key) == 'string' then
            table.insert(sb, string.format('[\'%s\'] = ', tostring(key)))
         elseif type(key) == 'number' then
            table.insert(sb, string.format('[%s] = ', tonumber(key)))
         else
            table.insert('[??] = ')
         end
         
         if type(value) == "table" and not done[value] then
           done [value] = true
           table.insert(sb, "{\n");
           table.insert(sb, table_print (value, indent + 2, done))
           table.insert(sb, string.rep (" ", indent)) -- indent it
           table.insert(sb, "},\n");
         elseif type(value) == 'string' then
           table.insert(sb, string.format("\"%s\",\n", tostring(value)))
         elseif type(value) == 'number' then
           table.insert(sb, string.format("%s,\n", tostring(value)))
         else
           table.insert(sb, '??,')
         end
       end
    end

    for key, value in ipairs (tt) do
         table.insert(sb, string.rep (" ", indent)) -- indent it

--         if type(key) == 'string' then
--            table.insert(sb, string.format('[\'%s\'] = ', tostring(key)))
--         elseif type(key) == 'number' then
--            table.insert(sb, string.format('[%s] = ', tonumber(key)))
--         else
--            table.insert('[??] = ')
--         end
         
         if type(value) == "table" and not done[value] then
           done [value] = true
           table.insert(sb, "{\n");
           table.insert(sb, table_print (value, indent + 2, done))
           table.insert(sb, string.rep (" ", indent)) -- indent it
           table.insert(sb, "},\n");
         elseif type(value) == 'string' then
           table.insert(sb, string.format("\"%s\",\n", tostring(value)))
         elseif type(value) == 'number' then
           table.insert(sb, string.format("%s,\n", tostring(value)))
         else
           table.insert(sb, '??,')
         end
    end

    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function M.to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

return M

