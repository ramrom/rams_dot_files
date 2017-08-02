require 'pry'
require 'espeak'

class SayStuff
  include ESpeak

  def initialize
  end

  def speak
    speaker = Speech.new('YO!')
    speaker.speak
  end
end

binding.pry

puts 'hi'
