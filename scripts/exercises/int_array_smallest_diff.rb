def smallest_diff(arr1, arr2)
  raise "not integer arrays" if arr1.any? { |i| !i.kind_of?(Integer) } || arr2.any? { |i| !i.kind_of?(Integer) }
  arr1 = arr1.sort
  arr2 = arr2.sort
  if arr1.min > arr2.max
    arr1.min - arr2.max
  elsif arr2.min > arr1.max
    arr2.min - arr1.max
  else
    overlaparr_find_min(arr1, arr2)
  end
end

# assumes sorted integer arrays
def overlaparr_find_min(arr1, arr2)
  if arr1.max > arr2.max
    largermaxarr = arr1
    smallermaxarr = arr2
  else
    largermaxarr = arr2
    smallermaxarr = arr1
  end

  indsmaller = smallermaxarr.size - 1
  indlarger = 0

  diff = largermaxarr[indlarger] - smallermaxarr[indsmaller]
  while diff > 0
    diff = largermaxarr[indlarger] - smallermaxarr[indsmaller]
    indlarger -= 1
    indsmaller += 1 
  end
  diff
end

[
  [ [1,2,3], [4,5,6] ],
  [ [1,2,3], [-1,-2] ],
  [ [-3,4], [-4,2] ]
].each do |scen|
  puts "array 1: #{scen[0]}, array 2: #{scen[1]}, smallest diff: #{smallest_diff(scen[0], scen[1])}"
end

