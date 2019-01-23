$counter = 0
def countmethods(numstairs)
  nummethods = { 0 => 0, 1 => 1, 2 => 2, 3 => 4 } 
  count(numstairs, nummethods)
end

def timeit(&block)
  t = Time.now
  yield(t)
  puts "time: #{Time.now - t}"
end

def count(numstairs, methodcount)
  $counter += 1
  puts "#{$counter}" if $counter % 1000000 == 0
  if methodcount[numstairs]
    methodcount[numstairs]
  else
    if $dont_memoize
      count(numstairs - 1, methodcount) + 2 * count(numstairs - 2, methodcount) + 4 * count(numstairs - 3, methodcount)
    else
      methodcount[numstairs] = count(numstairs - 1, methodcount) + 2 * count(numstairs - 2, methodcount) + 4 * count(numstairs - 3, methodcount)
    end
  end
end

$dont_memoize = true
#puts countmethods(30)
timeit do |st|
  puts st
  puts countmethods(30)
end
