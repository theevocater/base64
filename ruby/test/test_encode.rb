require 'test/unit'
require 'MyBase64'

class EncodeTest < Test::Unit::TestCase
  def test_encode_case0
    assert_equal MyBase64.encode_case0(104), ["a"]
  end

  def test_encode_case1
    assert_equal MyBase64.encode_case1(104, 97), ["G"]
  end

  def test_encode_case2
    assert_equal MyBase64.encode_case2(97, 116), ["F", "0"]
  end

  def test_empty_string
    assert_equal MyBase64.encode64(""), ""
  end

  def test_one
    assert_equal MyBase64.encode64("h"), "aA=="
  end

  def test_two
    assert_equal MyBase64.encode64("ha"), "aGE="
  end
  
  # basic case of 3 bytes => 4 * 6bits
  def test_hat
    assert_equal MyBase64.encode64("hat"), "aGF0"
  end

  # needs 2 pads
  def test_chat
    assert_equal MyBase64.encode64("chat"), "Y2hhdA=="
  end

  # needs 1 pad
  def test_hatch
    assert_equal MyBase64.encode64("hatch"), "aGF0Y2g="
  end

  # 6 => 8
  def test_hatche
    assert_equal MyBase64.encode64("hatche"), "aGF0Y2hl"
  end
end

