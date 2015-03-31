require 'minitest_helper'

class TestGogoDriver < Minitest::Test
  def test_main
    driver = GogoDriver.new
    driver.go('http://gogotanaka.me/')
    assert driver.has_text?('gogotanaka')
    driver.quit
  end

  def test_facebook
    driver = GogoDriver.new
    driver.go('https://www.facebook.com/')
    driver.find('input#email').fill('foo@foo.com')
    driver.find('input#pass').fill('password')
    driver.submit
    assert driver.has_text?('Please re-enter your password')
    driver.quit
  end
end
