def fact(num)
  product = 1
  (1..num).each { |i| product = product * i }
  product
end

def factnumzero(num)
  numzeros = 0
  poweroffive = 1
  while num / (5 ** poweroffive) > 0
    numzeros += num / (5 ** poweroffive)
    poweroffive += 1
  end
  numzeros
end

(1..125).each do |num|
  actualzeros = fact(num).to_s.match(/[1-9]*(0*)$/)[1].size
  puts "number: #{num}, factorial: #{fact(num)}, numzeros calc: #{factnumzero(num)}, actual zeros: #{actualzeros}"
end
