require 'test/unit'
require "base64"
require 'MyBase64'

class RandomTest < Test::Unit::TestCase
  def test_random
    iterations = 100
    assert_nothing_raised {
      iterations.times.map {
        # found this method when looking up the ruby "random" module
        str_length = rand(10000).to_i
        the_string = (36**(str_length-1) + rand(36**str_length)).to_s(36)
        encoded_mine = MyBase64.encode64(the_string)
        encoded_lib = Base64.strict_encode64(the_string)
        if encoded_mine != encoded_lib
          puts encoded_mine
          puts encoded_lib
          raise "Failed to encode " + the_string
        end

        decoded_mine = MyBase64.decode64(encoded_mine)
        decoded_lib = Base64.strict_decode64(encoded_lib)

        if decoded_mine != decoded_lib
          puts encoded_mine
          puts decoded_mine
          puts decoded_lib
          raise "Failed to decode: " + the_string
        end
      }
    }
  end
end
