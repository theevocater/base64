require 'test/unit'
require 'MyBase64'

class ThroughTest < Test::Unit::TestCase
  def test_empty_string
    assert_equal MyBase64.decode64(MyBase64.encode64("")), ""
  end

  def test_one
    assert_equal MyBase64.decode64(MyBase64.encode64("h")), "h"
  end

  def test_two
    assert_equal MyBase64.decode64(MyBase64.encode64("ha")), "ha"
  end
  
  # basic case of 3 bytes => 4 * 6bits
  def test_hat
    assert_equal MyBase64.decode64(MyBase64.encode64("hat")), "hat"
  end

  # needs 2 pads
  def test_chat
    assert_equal MyBase64.decode64(MyBase64.encode64("chat")), "chat"
  end

  # needs 1 pad
  def test_hatch
    assert_equal MyBase64.decode64(MyBase64.encode64("hatch")), "hatch"
  end

  # 6 => 8
  def test_hatche
    assert_equal MyBase64.decode64(MyBase64.encode64("hatche")), "hatche"
  end
end

