require 'selenium-webdriver'
require 'nokogiri'

require 'kirchhoff/common_interface'
require 'kirchhoff/logger'

module Kirchhoff
  class Driver
    attr_accessor :__driver__, :waiter

    include Kirchhoff::CommonInterface

    def current_url
      @__driver__.current_url
    end

    def quit
      @__driver__.quit
    end

    def reload
      @__driver__.navigate.refresh
    end

    def initialize(browser: :chrome, timeout: 6)
      @__driver__ = Selenium::WebDriver.for(browser)
      @waiter     = Selenium::WebDriver::Wait.new(timeout: timeout)
    end

    def go url
      @__driver__.navigate.to(url)
      Kirchhoff::Logger.call :info, "visiting #{url}..."
    end

    def submit
      $focus.submit
      Kirchhoff::Logger.call :info, "submit form ..."
    end

    def to_html
      attribute "outerHTML"
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

    def to_html
      @__driver__.page_source
    end

    private def weak_find selector
      @__driver__.find_element(css: selector)
    end

    private def weak_multi_find selector
      @__driver__.find_elements(css: selector)
    end

    private def weak_find_text text
      @__driver__.find_element(xpath: "//*[text()[contains(.,\"#{text}\")]]")
    end

    private def weak_multi_find_text text
      @__driver__.find_elements(xpath: "//*[text()[contains(.,\"#{text}\")]]")
    end
  end
end

class Selenium::WebDriver::Element
  include Kirchhoff::CommonInterface
  alias :origin_click :click

  def fill(text)
    $focus = self
    send_key(text)
    Kirchhoff::Logger.call :info, "fill '#{text}'"
  end

  def to_html
    attribute "outerHTML"
  end

  private def weak_find selector
    self.find_element(css: selector)
  end

  private def weak_find_text text
    self.find_elements(xpath: "//*[text()[contains(.,\"#{text}\")]]")
  end

  def waiter
    Selenium::WebDriver::Wait.new(timeout: 5)
  end
end
