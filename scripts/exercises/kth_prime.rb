def find_kth_357_prime_brute(num, k)
  factors = {}
  (1..num).each do |i|
    prime_factorize(i, factors)
  end
  puts factors
  factors.select { |k,v| only_contains_357?(v) }.keys.sort[k]
end

def only_contains_357?(factors)
  factors.all? { |f| [3,5,7].include?(f) }
end

def prime_factorize(num, factor_hash)
  factors_for_num = []
  original_num = num
  (2..num).each do |potential_factor|
    while num % potential_factor == 0
      factors_for_num << potential_factor
      newnum = num / potential_factor
      if factor_hash[newnum]
        factor_hash[num] = factors_for_num + factor_hash[newnum]
        return
      end
      num = newnum
    end
  end
  factor_hash[original_num] = factors_for_num
end

# return a list of unique primes below a number, ordered
def find_primes_below(num)
end

def find_kth_357_prime(k)
  current_largest = 7
  ordered_357_multiples = [1,3,5,7]
  threes, fives, sevens = 1, 1, 1
  (1..k-4).each do |i|
    #next_three = current_largest * 3
    #next_five = current_largest * 3
    #next_seven = current_largest * 3
    #
    #current_largest = 
    #ordered_357_multiples << current_largest
  end

  ordered_357_multiples[k]
end

puts find_kth_357_prime_brute(100, 12)
