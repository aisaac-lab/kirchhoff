require 'selenium-webdriver'

require 'smart_driver/common_interface'

class SmartDriver
  attr_accessor :__driver__
  attr_reader :log_dir_path
  include SmartDriver::CommonInterface

  def initialize(url=nil, log_dir_path="./log", browser=:chrome)
    @__driver__ = Selenium::WebDriver.for(browser)
    FileUtils.mkdir_p log_dir_path
    @log_dir_path = log_dir_path
    go(url) if url
  end

  def go(url)
    logging :info, "visiting #{url}..."
    @__driver__.navigate.to(url)
  end

  def reload
    @__driver__.navigate.refresh
  end

  def submit
    logging :info, "submit form ..."
    $focus.submit if $focus
  end

  def exec_js(js_code)
    @__driver__.execute_script js_code
  end

  def save_html(file_name="log.html")
    File.open("#{@log_dir_path}/#{file_name}", 'w') { |f| f.write(@__driver__.page_source) }
  end

  def save_png(file_name="log.png")
    @__driver__.save_screenshot "#{@log_dir_path}/#{file_name}"
  end

  def method_missing(method, *args, &block)
    @__driver__.respond_to?(method) ? @__driver__.send(method, *args, &block) : super
  end

  def switch_window(num)
    @__driver__.switch_to.window @__driver__.window_handles[num]
  end
end

class Selenium::WebDriver::Element
  include SmartDriver::CommonInterface

  def fill(text)
    $focus = self
    logging :info, "fill '#{text}'"
    send_key(text)
  end
end
