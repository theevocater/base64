class MyBase64
  # The standard base64 alphabet
  @@alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

  # Encode the first 6 bytes.
  def self.encode_case0(x)
    [@@alphabet[x >> 2]]
  end

  # Encode the second 6 bytes.
  def self.encode_case1(x, y)
    [@@alphabet[((x & 3) << 4) | (y >> 4)]]
  end

  # Encode the third and fourth 6 bytes.
  def self.encode_case2(x, y)
    [@@alphabet[(x & 15) << 2 | y >> 6], @@alphabet[y & 63]]
  end

  # Encodes a string into its base64 representation. Follows the basic model
  # of:
  #
  # AAAAAAAA-BBBBBBBB-CCCCCCCC
  # AAAAAA-AABBBB-BBBBCC-CCCCCC
  def self.encode64(string)
    result = []
    (string.chars.each_slice(3) { |chars|
      chars.map! { |char| char.ord }
      case chars.length
        when 1
          result +=
            encode_case0(chars[0]) +
            [@@alphabet[(chars[0] & 3) << 4], "=="]
        when 2
          result +=
            encode_case0(chars[0]) +
            encode_case1(chars[0], chars[1]) +
            [@@alphabet[(chars[1] & 15) << 2], "="]
        when 3
          result +=
            encode_case0(chars[0]) +
            encode_case1(chars[0], chars[1]) +
            encode_case2(chars[1], chars[2])
      end
    })
    result.flatten.join()
  end

  # Decode the first 8 bytes
  def self.decode_case0(x, y)
    check_params_decode(x, y)
    [(x << 2 | y >> 4).chr]
  end

  # Decode the second 8 bytes
  def self.decode_case1(x, y)
    check_params_decode(x, y)
    [((x & 15) << 4 | y >> 2).chr]
  end

  # Decode the third 8 bytes
  def self.decode_case2(x, y)
    check_params_decode(x, y)
    [((x & 3) << 6 | y).chr]
  end

  # A sanity check to ensure the parameters are valid
  def self.check_params_decode(x, y)
    if not (x >= 0 and x < @@alphabet.size) and (y >= 0 and y < @@alphabet.size)
      raise "Bad parameters + " + [x, y]
    end
  end

  # Decodes a string from its base64 representation. Follows the basic model
  # of:
  #
  # AAAAAA-BBBBBB-CCCCCC-DDDDDD
  # AAAAAABB-BBBBCCCC-CCDDDDDD
  def self.decode64(string)
    string = string.gsub(/=+$/,"")
    result = []
    string.chars.each_slice(4) { |chars|
      chars.map! { |char| @@alphabet.index(char) }
      case chars.length
        when 1
          raise "Malformed Input, deconding string the wrong size"
        when 2
          result +=
            decode_case0(chars[0], chars[1])
        when 3
          result +=
            decode_case0(chars[0], chars[1]) +
            decode_case1(chars[1], chars[2])
        when 4
          result +=
            decode_case0(chars[0], chars[1]) +
            decode_case1(chars[1], chars[2]) +
            decode_case2(chars[2], chars[3])
      end

    }
    result.flatten.join()
  end
end
