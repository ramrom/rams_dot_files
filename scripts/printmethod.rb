#!/usr/bin/ruby

if !ARGV[0] 
  puts 'no file name given'
  exit(1)
end

if !ARGV[1] 
  puts 'no method name given'
  exit(1)
end

method_found = false
nested_counter = 1
#nest_patterns = ['if ','case ','begin ','while ','until ','for ', ' do ', 'module ', 'class ']
nest_patterns = ['if ','case ','begin ','while ','until ','for ', ' do ']

f = File.open(ARGV[0],'r')


f.each_line do |line|
  method_found = true if line.chomp.include?("def #{ARGV[1]}") 
  if method_found && nested_counter > 0 
    puts line
    nest_patterns.each do |pattern|
      if line.downcase.include?(pattern) && !comment?(line)
        nested_counter = nested_counter + 1
    	break
      end
    end
    if line.downcase.strip[0..3] == "end "
      nested_counter = nested_counter - 1
    end
  end
  break if method_found && nested_counter == 0 
  #puts "counter: #{nested_counter}"
end

f.close

def does_file_contain_method(filename,methodname)
  
end

def comment?(line)
end
