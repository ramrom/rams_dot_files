class LCDClock
  attr_reader :digits, :size

  def self.render(digits, size)
    new(digits, size).render
  end

  def initialize(digits, size)
    @digits = digits
    @size = size
  end

  def render
    render_single_line_seg("top")
    render_multi_line_seg("top_mid")
    render_single_line_seg("mid")
    render_multi_line_seg("bot_mid")
    render_single_line_seg("bot")
  end

  def render_single_line_seg(seg)
    unless %w[top mid bot].include?(seg)
      raise ArgumentError, "#{seg} given: must be top mid or bot"
    end
    digits.size.times do |dig|
      render_digit(digits[dig], seg)
    end
    puts ""
  end

  def render_multi_line_seg(seg)
    unless %w[top_mid bot_mid].include?(seg)
      raise ArgumentError, "#{seg} given: must be top_mid or bot_mid"
    end
    size.times do |line|
      digits.size.times do |dig|
        render_digit(digits[dig], seg)
      end
      puts ""
    end 
  end

  def render_digit(digit, seg)
    case seg
    when "top"
      case digit
      when "0", "2", "3", "5", "7", "8", "9", "0"
        print " " + "-" * size + " "
      else print " " * (size + 2)
      end
    when "top_mid"
      case digit
      when "0", "4", "8", "9"
        print "|" + " " * size + "|"
      when "1", "2", "3", "7"
        print " " * (size + 1) + "|"
      when "5", "6"
        print "|" + " " * (size + 1)
      end
    when "mid"
      case digit
      when "2", "3", "4", "5", "6", "8", "9"
        print " " + "-" * size + " "
      else print " " * (size + 2)
      end
    when "bot_mid"
      case digit
      when "0", "6", "8" 
        print "|" + " " * size + "|"
      when "1", "3", "4", "5", "7", "9"
        print " " * (size + 1) + "|"
      when "2"
        print "|" + " " * (size + 1)
      end
    when "bot"
      case digit
      when "0","2", "3", "5", "6", "8"
        print " " + "-" * size + " "
      else print " " * (size + 2)
      end
    end
    print " " * (size / 3)
  end
end
