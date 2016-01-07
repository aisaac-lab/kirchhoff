require 'test_helper'

class SmartDriverTest < Minitest::Test
  def test_main
    driver = SmartDriver.new('http://gogotanaka.me/')
    assert driver.has_text?('gogotanaka')
    assert_equal driver.find("a").to_html, "<a href=\"http://gogotanaka.hatenablog.com\">\n            <i class=\"fa fa-rss-square\" ,=\"\" style=\"font-size: 50px\"></i>\n          </a>"
    driver.find_text("Hilbert").click()

    driver.switch_window(-1)
    sleep 0.2

    assert driver.find("div").find("div").has?("a")
    assert driver.has_text?('Implement mathematics.')

    driver.maybe do
      driver.find("noooooo")
    end

    driver.quit
  end

  def test_facebook
    driver = SmartDriver.new('https://www.facebook.com/')
    driver.find('input#email') do |e|
      e.fill('foo@foo.com')
    end
    driver.find('input#pass') do |e|
      e.fill('foo@foo.com')
    end

    driver.submit
    assert driver.has_text?("The password")
    driver.quit
  end

  def test_twitter
    driver = SmartDriver.new('https://mobile.twitter.com/session/new')
    driver.finds(".signup-field input").each do |e|
      e.fill("tanaka")
    end
    driver.find("button#signupbutton").click
    assert driver.has_text?('The username and password you entered did not match our records. Please double-check and try again.')
    driver.quit
  end
end
