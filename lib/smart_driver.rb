require 'selenium-webdriver'

require 'smart_driver/common_interface'

class SmartDriver
  attr_accessor :__driver__
  attr_reader :log_dir_path
  include SmartDriver::CommonInterface

  def initialize(url=nil, browser=:chrome)
    @__driver__ = Selenium::WebDriver.for(browser)
    go(url) if url
  end

  def go(url, t=10, &block)
    logging :info, "visiting #{url}..."
    @__driver__.navigate.to(url)
    if block_given?
      wait = Selenium::WebDriver::Wait.new(timeout: t)
      wait.until(&block)
    end
  end

  def reload
    @__driver__.navigate.refresh
  end

  def submit(n=20)
    logging :info, "submit form ..."
    $focus.submit
    if block_given?
      n.times do
        break if yield()
        sleep 0.5
      end
    end
  end

  def exec_js(js_code)
    @__driver__.execute_script js_code
  end

  def save_html(file_path)
    File.open(file_path, 'w') { |f| f.write(@__driver__.page_source) }
  end

  def save_png(file_path)
    @__driver__.save_screenshot file_path
  end

  def method_missing(method, *args, &block)
    @__driver__.respond_to?(method) ? @__driver__.send(method, *args, &block) : super
  end

  def switch_window(num)
    @__driver__.switch_to.window @__driver__.window_handles[num]
  end

  def maybe(&block)
    block.call()
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end
end

class Selenium::WebDriver::Element
  include SmartDriver::CommonInterface
  alias :origin_click :click

  def click(t=10, &block)
    origin_click()
    if block_given?
      wait = Selenium::WebDriver::Wait.new(timeout: t)
      wait.until(&block)
    end
  end

  def fill(text)
    $focus = self
    logging :info, "fill '#{text}'"
    send_key(text)
  end
end
