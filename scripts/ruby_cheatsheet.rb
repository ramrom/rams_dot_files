# Find all objects of a type and do something to them
ObjectSpace.each_object(Array) { |ob| puts ob.object_id }

# Find which parent class or module defines a method
Array.instance_method(:map)

# For class methods
Array.method(:try_convert)

# Get source location
Array.instance_method(:map).source_location

# To get mem consumption of object
require 'objspace'
i = 342423423423423423432342
ObjectSpace.memsize_of(i)
