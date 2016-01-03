require 'test_helper'

class SmartDriverTest < Minitest::Test
  def test_main
    driver = SmartDriver.new('http://gogotanaka.me/')
    refute_nil driver.find_text('gogotanaka')
    assert_equal driver.find("a").to_html, "<a href=\"http://gogotanaka.hatenablog.com\">\n            <i class=\"fa fa-rss-square\" ,=\"\" style=\"font-size: 50px\"></i>\n          </a>"
    driver.find_text("Hilbert").click()

    driver.switch_window(-1)
    sleep 0.2

    refute_nil driver.find_text('Implement mathematics.')
    driver.quit
  end

  def test_facebook
    driver = SmartDriver.new('https://www.facebook.com/')
    driver.find('input#email').fill('foo@foo.com')
    driver.find('input#pass').fill('password')
    driver.submit
    refute_nil driver.find_text("The password")
    driver.quit
  end

  def test_twitter
    driver = SmartDriver.new('https://mobile.twitter.com/session/new')
    driver.finds(".signup-field input").each do |e|
      e.fill("tanaka")
    end
    driver.find("button#signupbutton").click
    refute_nil driver.find_text('The username and password you entered did not match our records. Please double-check and try again.')
    driver.quit
  end

  def test_utils
    driver = SmartDriver.new('http://gogotanaka.me/', "./tmp/log")
    driver.save_png
    driver.save_html
  end
end
