#! /usr/bin/lua

p = require('performance')

p.calibrate()


function file_write_random_flush_cache_sync(d_filename, data)
   -- Flush disk cache
   os.execute('sync; echo 3 > /proc/sys/vm/drop_caches')
   
   -- Write output file
   local f_out = io.open(d_filename, 'wb')
   f_out:write(data)   
   f_out:close()

   os.execute('sync')
--   os.execute('rm ' .. d_filename)
end


for i = 1, 5 do
   local f_in = io.open('/dev/urandom', 'rb')
   local data_1M = f_in:read(16*1024*1024)
--   local s = data_1M:match('.$')
--   print(string.byte(s))
   f_in:flush()
   f_in:close()
   os.execute('touch tmp-file' .. i)
   os.execute('sync; echo 3 > /proc/sys/vm/drop_caches')
   
   print(collectgarbage('count'))
   collectgarbage('collect')
   collectgarbage('collect')
   print(collectgarbage('count'))
   r = p.measure(function() file_write_random_flush_cache_sync('tmp-file' .. i, data_1M) end, 0.01, 3)
   print(r.t_min, r.t_ave, r.t_max, r.t_total, r.n)
end
