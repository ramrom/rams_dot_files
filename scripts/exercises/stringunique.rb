def is_unique?(str)
  return true if str.size == 1
  (1..str.size-1).each do |i|
    (0..i-1).each do |j|
      return false if str[i] == str[j]
    end
  end
  true
end

def is_unique2?(str)
  strarr = (0..str.size-1).each_with_object([]) { |i, obj| obj << str[i] }
  strarr = strarr.sort
  return true if strarr.size == 1
  (1..strarr.size-1).each do |i|
    return false if strarr[i] == strarr[i-1]
  end
  true
end

puts is_unique?("dude")
puts is_unique2?("dude")
puts is_unique?("ee")
puts is_unique2?("ee")

def permuation?(stra, strb)
  inv1 = (0..stra.size-1).each_with_object({}) do |i, hash|
    hash[stra[i]] ||= 0
    hash[stra[i]] += 1
  end
  inv2 = (0..strb.size-1).each_with_object({}) do |i, hash|
    hash[strb[i]] ||= 0
    hash[strb[i]] += 1
  end
  inv1 == inv2
end

puts permuation?("dude ", "edud")
