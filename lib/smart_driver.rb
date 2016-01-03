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

  def find(selector)
    logging :info, "find #{selector}..."
    @__driver__.find_element(css: selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "#{selector} cannot be found"
    nil
  end

  def finds(selector)
    logging :info, "finds #{selector}..."
    @__driver__.find_elements(css: selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "#{selector} cannot be found"
    nil
  end

  def find_text(text)
    logging :info, "find text '#{text}'..."
    @__driver__.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "text '#{text}' cannot be found"
    nil
  end

  def finds_text(text)
    logging :info, "finds text '#{text}'..."
    @__driver__.find_elements({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "text #{text} cannot be found"
    nil
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
end

class Selenium::WebDriver::Element
  include SmartDriver::CommonInterface

  def find(selector)
    logging :info, "find #{selector} in element..."
    self.find_element(css: selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "#{selector} cannot be found in element..."
    nil
  end

  def finds(selector)
    logging :info, "finds #{selector} in element..."
    self.find_elements(css: selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "#{selector} cannot be found in element..."
    nil
  end

  def find_text(text)
    logging :info, "find text '#{text}'..."
    self.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "text '#{text}' cannot be found"
    nil
  end

  def finds_text(text)
    logging :info, "finds text '#{text}'..."
    self.find_elements({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "text #{text} cannot be found"
    nil
  end

  def fill(text)
    $focus = self
    logging :info, "fill '#{text}'"
    send_key(text)
  end
end
