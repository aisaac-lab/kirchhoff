require 'selenium-webdriver'
require 'nokogiri'

require 'kirchhoff/common_interface'
require 'kirchhoff/logger'

module Kirchhoff
  class Driver
    attr_accessor :__driver__, :default_timeout
    attr_reader :log_dir_path
    include Kirchhoff::CommonInterface

    def find_element selector
      @__driver__.find_element selector
    end

    def find_elements selector
      @__driver__.find_elements selector
    end

    def current_url
      @__driver__.current_url
    end

    def quit
      @__driver__.quit
    end

    def initialize(browser: :chrome, default_timeout: 6)
      @__driver__      = Selenium::WebDriver.for(browser)
      @default_timeout = default_timeout
    end

    def go url
      @__driver__.navigate.to(url)
      Kirchhoff::Logger.call :info, "visiting #{url}..."
    end

    def reload
      @__driver__.navigate.refresh
    end

    def submit
      $focus.submit
      Kirchhoff::Logger.call :info, "submit form ..."
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

    def switch_window num
      @__driver__.switch_to.window @__driver__.window_handles[num]
    end

    def wait_element(selector, maybe: true, t: nil)
      wait = Selenium::WebDriver::Wait.new(timeout: (t || @default_timeout))
      wait.until { self.find_element(css: selector) }
    rescue Selenium::WebDriver::Error::TimeOutError
      unless maybe
        raise Selenium::WebDriver::Error::TimeOutError, "selector: #{selector}"
      end
    end

    def wait_text(text, maybe: true, t: nil)
      wait = Selenium::WebDriver::Wait.new(timeout: (t || @default_timeout))
      wait.until { self.find_element(xpath: "//*[text()[contains(.,\"#{text}\")]]") }
    rescue Selenium::WebDriver::Error::TimeOutError
      unless maybe
        raise Selenium::WebDriver::Error::TimeOutError, "text: #{text}"
      end
    end

    def to_html
      self.__driver__.page_source
    end
  end
end

class Selenium::WebDriver::Element
  include Kirchhoff::CommonInterface
  alias :origin_click :click

  def click
    origin_click()
  end

  def fill(text)
    $focus = self
    send_key(text)
    Kirchhoff::Logger.call :info, "fill '#{text}'"
  end
end
