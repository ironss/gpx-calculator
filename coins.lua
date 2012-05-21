#! /usr/bin/lua

local max = arg[1] or 100
tosses = {}

math.randomseed(os.time())
function toss_coin()
   if math.random() > 0.5 then
      return 'H'
   else
      return 'T'
   end
end


for i = 1, max do
   tosses[#tosses+1] = toss_coin()
end

--print(table.concat(tosses))

sequence_lengths = {}
current_sequence = tosses[1]
current_length = 1
maximum_length = 0
for i = 2, #tosses do
   if tosses[i] == current_sequence then
      current_length = current_length + 1
   else
      if sequence_lengths[current_length] == nil then
         sequence_lengths[current_length ] = 0
      end
      sequence_lengths[current_length] = sequence_lengths[current_length] + 1
      maximum_length = math.max(maximum_length, current_length)
      current_sequence = tosses[i]
      current_length = 1
   end
end

      if sequence_lengths[current_length] == nil then
         sequence_lengths[current_length ] = 0
      end
      sequence_lengths[current_length] = sequence_lengths[current_length] + 1
      maximum_length = math.max(maximum_length, current_length)

for i = 1, maximum_length do
   if sequence_lengths[i] == nil then
      sequence_lengths[i] = 0
   end
   print(i, sequence_lengths[i])
end
