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
    if string.size == 0
      ""
    end 

    prev = 0
    i = 0
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
                else
                  []
                end
      i += 1
      prev = curr
    end

    result += case mod 
              when 0
                [alphabet[(prev & 3) << 4], "=="]
              when 1
                [alphabet[(prev & 15) << 2], "="]
              else
                []
              end

    result.join()
  end
end

puts MyBase64.encode_case0(104) == ["a"]
puts MyBase64.encode_case1(104, 97) == ["G"]
puts MyBase64.encode_case2(97, 116) == ["F", "0"]

puts ""
the_string = "hat"
puts the_string
puts MyBase64.encode64(the_string)
puts Base64.encode64(the_string)
