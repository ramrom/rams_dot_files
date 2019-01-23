# count the number of times the digit 2 appears in a list of numbers from 0 to n

def count_twos(num)
  raise "not a Fixnum" unless num.kind_of?(Fixnum)
  count = 0
  num_by_digits = num.to_s.split('')
  max_sig_digit_power = num_by_digits.size
  num_by_digits.each_with_index do |digit, i|
    count += digit.to_i * two_in_ten(max_sig_digit_power - i - 1)
    if digit.to_i > 2
      count += 10 ** (max_sig_digit_power - i - 1)
    elsif digit.to_i == 2
      count += num_by_digits[i+1..-1].join('').to_i + 1
    end
  end
  count
end

# f(n) -> 10 * f(n-1) + 10 ^ (n-1) , e.g. 100 n=2, f(1) = 1 (correct), f(2) = 20, f(3) = 300
def two_in_ten(power)
  raise "input: #{power}, power invalid" if power < 0
  return 0 if power == 0
  10 * two_in_ten(power-1) + 10 ** (power-1)
end

def count_twos_brute(num)
  count = 0
  raise "not a Fixnum" unless num.kind_of?(Fixnum)
  (1..num).each_with_index do |i|
    count += i.to_s.count("2")
  end
  count
end

[20, 300, 566, 987, 1000, 1100, 1199, 1200,  2234, 3211, 123456].each do |scenario|
  #next unless scenario == 1200
  puts "num: #{scenario}, brute force: #{count_twos_brute(scenario)}, smarter: #{count_twos(scenario)}"
end
