require 'test_helper'

class SmartDriverTest < Minitest::Test
  HOME_IMG_LISTS_CLASS = 'div._nljxa a'
  COMMENT_LI_CLASS = 'ul._mo9iw li._nk46a'
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

  def test_instagram
    @driver = SmartDriver.new

    @driver.go("https://www.instagram.com/instagram/") do
      @driver.find(HOME_IMG_LISTS_CLASS)
    end

    @driver.maybe do
      @driver.find("._oidfu").click()
    end

    count = @driver.finds(HOME_IMG_LISTS_CLASS).count
    new_count = count
    loop do
      @driver.exec_js %|window.scrollTo(0,0);|
      sleep 1
      10.times do
        @driver.exec_js %|window.scrollTo(0,document.body.scrollHeight);|
        sleep 1
        new_count = @driver.finds(HOME_IMG_LISTS_CLASS).count
        break if count < new_count
      end
      break if count == new_count
      count = new_count
      p count

      break if count >= 60
    end
    assert_equal 60, count

    @driver.finds(HOME_IMG_LISTS_CLASS).each do |img_a|
      img_a.click { @driver.find("._3eajp") }

      p @driver.current_url

      @driver.find("._3eajp").click()
    end
  end
end
