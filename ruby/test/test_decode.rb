require 'test/unit'
require 'MyBase64'

class DecodeTest < Test::Unit::TestCase
  def test_decode_case0
    assert_equal MyBase64.decode_case0(26, 6), ["h"]
  end

  def test_decode_case1
    assert_equal MyBase64.decode_case1(6, 5), ["a"]
  end

  def test_decode_case2
    assert_equal MyBase64.decode_case2(5, 52), ["t"]
  end

  def test_empty_string
    assert_equal MyBase64.decode64(""), ""
  end
  
  def test_one
    assert_equal MyBase64.decode64("aA=="), "h"
  end

  def test_two
    assert_equal MyBase64.decode64("aGE="), "ha"
  end
  
  # simplest case of 4 * 6 bits => 3 bytes
  def test_hat
    assert_equal MyBase64.decode64("aGF0"), "hat"
  end

  # remove 2 pad
  def test_chat
    assert_equal MyBase64.decode64("Y2hhdA=="), "chat"
  end

  # remove 1 pad
  def test_hatch
    assert_equal MyBase64.decode64("aGF0Y2g="), "hatch"
  end

  # 8 => 6
  def test_hatche
    assert_equal MyBase64.decode64("aGF0Y2hl"), "hatche"
  end
end

