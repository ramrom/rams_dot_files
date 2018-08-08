require 'date'

prin = 345000

annual_int = 0.04
daily_int = annual_int / 365

d = Date.parse '2018-06-01'
d2 = Date.parse '2018-07-01'

int = (d2 - d + 1).to_i * daily_int * prin
puts int
