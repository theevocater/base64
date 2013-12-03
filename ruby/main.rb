require "base64"

class MyBase64
  @@alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

  def self.encode_case0(x)
    [@@alphabet[x >> 2]]
  end
  def self.encode_case1(x, y)
    [@@alphabet[((x & 3) << 4) | (y >> 4)]]
  end

  def self.encode_case2(x, y)
    [@@alphabet[(x & 15) << 2 | y >> 6], @@alphabet[y & 63]]
  end

  # AAAAAAAA-BBBBBBBB-CCCCCCCC
  # AAAAAA-AABBBB-BBBBCC-CCCCCC
  def self.encode64(string)
    prev = 0
    i = 0
    mod = -1
    result = []

    while i < string.size
      curr = string[i].ord
      mod = i % 3
      result += case mod
                when 0
                  encode_case0(curr)
                when 1
                  encode_case1(prev, curr)
                when 2
                  encode_case2(prev, curr)
                end
      i += 1
      prev = curr
    end

    result += case mod
              when 0
                [@@alphabet[(prev & 3) << 4], "=="]
              when 1
                [@@alphabet[(prev & 15) << 2], "="]
              else
                []
              end

    result.join()
  end

  def self.decode_case0(x, y)
    check_params_decode(x, y)
    [(x << 2 | y >> 4).chr]
  end


  def self.decode_case1(x, y)
    check_params_decode(x, y)
    [((x & 15) << 4 | y >> 2).chr]
  end

  def self.decode_case2(x, y)
    check_params_decode(x, y)
    [((x & 3) << 6 | y).chr]
  end

  def self.check_params_decode(x, y)
    if not (x >= 0 and x < @@alphabet.size) and (y >= 0 and y < @@alphabet.size)
      raise "Bad parameters + " + [x, y]
    end
  end

  # AAAAAA-BBBBBB-CCCCCC-DDDDDD
  # AAAAAABB-BBBBCCCC-CCDDDDDD
  def self.decode64(string)
    string = string.gsub(/=+$/,"")
    prev = 0
    i = 0
    string.chars.map {
      curr = @@alphabet.index(string[i])
      mod = i % 4
      result =
        case mod
        when 0
          []
        when 1
          decode_case0(prev, curr)
        when 2
          decode_case1(prev, curr)
        when 3
          decode_case2(prev, curr)
        end

      i += 1
      prev = curr
      result
    }.flatten.join
  end
end

puts MyBase64.encode_case0(104) == ["a"]
puts MyBase64.encode_case1(104, 97) == ["G"]
puts MyBase64.encode_case2(97, 116) == ["F", "0"]

puts MyBase64.encode64("")

puts MyBase64.decode64("")

puts MyBase64.decode_case0(26, 6) == ["h"]
puts MyBase64.decode_case1(6, 5) == ["a"]
puts MyBase64.decode_case2(5, 52) == ["t"]

puts ""
the_string = "hat"
puts the_string
puts MyBase64.encode64(the_string)
puts MyBase64.decode64(MyBase64.encode64(the_string))

puts ""
the_string = "chat"
puts the_string
puts MyBase64.encode64(the_string)
puts MyBase64.decode64(MyBase64.encode64(the_string))

puts ""
the_string = "hatch"
puts the_string
puts MyBase64.encode64(the_string)
puts MyBase64.decode64(MyBase64.encode64(the_string))

puts ""
the_string = "hatche"
puts the_string
puts MyBase64.encode64(the_string)
puts MyBase64.decode64(MyBase64.encode64(the_string))
