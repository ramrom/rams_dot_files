# Find all objects of a type and do something to them
ObjectSpace.each_object(Array) { |ob| puts ob.object_id }

# Find which parent class or module defines a method
Array.instance_method(:map)

# For class methods
Array.method(:try_convert)

# Get source location
Array.instance_method(:map).source_location

# pp source code for method
Array.instance_method(:map).source.display

# To get mem consumption of object
require 'objspace'
i = 342423423423423423432342
ObjectSpace.memsize_of(i)

# Another method, probably better to get an idea of mem size:
Marshal.dump(a).size

f = File.open 'path/somefile'; 
require 'json'; j = JSON.parse(f)
j.each_with_index { |data,i| f= File.open("newfile#{i}",'w'); f.write(data.to_json); f.close }
