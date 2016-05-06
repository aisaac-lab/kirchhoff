require 'test_helper'

class SmartDriverTest < Minitest::Test
  def test_main
    driver = Kirchhoff::Driver.new(default_timeout: 1)
    driver.go("file://#{`pwd`}/test/test.html")

    assert_nil driver.find("div#noexist")
    assert_instance_of Selenium::WebDriver::Element, driver.find("div#exist")

    assert_instance_of Selenium::WebDriver::Element, driver.wait_element("div#exist")

    assert_instance_of Selenium::WebDriver::Element, driver.wait_text("Hello")

    assert_nil driver.wait_element("div#noexist")
    assert_nil driver.wait_text("no")

    assert_raises Selenium::WebDriver::Error::TimeOutError do
      driver.wait_element("div#noexist", maybe: false)
    end

    assert_raises Selenium::WebDriver::Error::TimeOutError do
      driver.wait_text("no", maybe: false)
    end
    driver.quit
  end
  # def test_main
  #   binding.pry
  #   driver = Kirchhoff::Driver.new('http://gogotanaka.me/')
  #   assert driver.has_text?('gogotanaka')
  #   assert_equal driver.find("a").to_html, "<a href=\"http://gogotanaka.hatenablog.com\">\n            <i class=\"fa fa-rss-square\" ,=\"\" style=\"font-size: 50px\"></i>\n          </a>"
  #   driver.find_text("Hilbert").click()
  #
  #   driver.switch_window(-1)
  #   sleep 0.2
  #
  #   assert driver.has_text?('Implement mathematics.')
  #
  #   driver.maybe do
  #     driver.find("noooooo")
  #   end
  #
  #   driver.quit
  # end
  #
  # def test_facebook
  #   driver = Kirchhoff::Driver.new('https://www.facebook.com/')
  #   driver.find('input#email') do |e|
  #     e.fill('foo@foo.com')
  #   end
  #   driver.find('input#pass') do |e|
  #     e.fill('foo@foo.com')
  #   end
  #
  #   driver.submit
  #   assert driver.has_text?("The password")
  #   driver.quit
  # end
  #
  # def test_twitter
  #   driver = Kirchhoff::Driver.new('https://mobile.twitter.com/session/new')
  #   driver.finds(".signup-field input").each do |e|
  #     e.fill("tanaka")
  #   end
  #   driver.find("button#signupbutton").click
  #   assert driver.has_text?('The username and password you entered did not match our records. Please double-check and try again.')
  #   driver.quit
  # end

  HOME_IMG_LISTS_CLASS = 'div._nljxa a'
  COMMENT_LI_CLASS = %|ul._mo9iw li._nk46a[data-reactid*="$comment"]|
  def test_instagram
    @driver = Kirchhoff::Driver.new

    @driver.go("https://www.instagram.com/instagram/")
    @driver.find "._oidfu", &:click

    3.times do
      @driver.exec_js %|window.scrollTo(0,0);|
      sleep 1
      3.times do
        @driver.exec_js %|window.scrollTo(0,document.body.scrollHeight);|
        sleep 1
      end
    end

    count = @driver.multi_find(HOME_IMG_LISTS_CLASS).count
    assert(count > 100)

    # BEGIN # get_posts
    results = []
    @driver.multi_find(HOME_IMG_LISTS_CLASS)[1..10].each do |img_a|
      img = img_a.find("img")
      img_a.click
      @driver.wait_element "._3eajp"

      result_hash = {
        img_src:     trip_id(img[:src]),
        description: img[:alt],
        url:         @driver.current_url
      }

      # BEGIN #show_all_comments
      @driver.find_text "view all", &:click
      @driver.wait_text "load more comments"

      begin
        6.times do
          @driver.wait_element("button._ifrvy").click()
        end
      rescue
      end
      # END #show_all_comments

      comments = @driver.find("ul._mo9iw ") { |e|
        e.to_nokogiri.css(COMMENT_LI_CLASS).map { |li|
          {
            username: li.at('a').text,
            contents: li.at('span').text
          }
        }
      } || []

      result_hash[:comments] = comments
      results << result_hash

      @driver.find("._3eajp").click()
    end
    # END #get_posts

    assert_equal 10, results.count
  end

  private def trip_id(img_src)
    img_src.scan(%r|^.+/(.+)$|)[0][0]
  end
end
