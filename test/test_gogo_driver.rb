require 'minitest_helper'

class TestGogoDriver < Minitest::Test
  def test_main
    driver = GogoDriver.new
    driver.go('http://gogotanaka.me/')
    assert driver.has_text?('gogotanaka')
    driver.quit
  end
end
