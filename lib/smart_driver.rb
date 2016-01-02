require 'selenium-webdriver'

class SmartDriver
  attr_accessor :__driver__

  def initialize(url=nil, browser=:chrome)
    @__driver__ = Selenium::WebDriver.for(browser)
    go(url) if url
  end

  def go(url)
    logging :info, "visiting #{url}..."
    @__driver__.navigate.to(url)
  end

  def reload
    @__driver__.navigate.refresh
  end

  def find(selector)
    logging :info, "find #{selector}..."
    @__driver__.find_element(css: selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "#{selector} cannot be found"
  end

  def finds(selector)
    logging :info, "finds #{selector}..."
    @__driver__.find_elements(css: selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    logging :fail, "#{selector} cannot be found"
  end

  # http://stackoverflow.com/questions/11908249/debugging-element-is-not-clickable-at-point-error
  def scroll(selector)
    logging :info, "scroll to #{selector}..."
    element = find(selector)
    exec_js "window.scrollTo(#{element.location.x},#{element.location.y})"
    element
  end

  def has?(selector)
    !!find(selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def has_text?(text)
    !!@__driver__.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def click(selector)
    logging :info, "click #{selector}..."
    has?(selector) ? find(selector).click : false
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

  def method_missing(method, *args, &block)
    @__driver__.respond_to?(method) ? @__driver__.send(method, *args, &block) : super
  end

  private
    def logging(sym, text)
      label = case sym
      when :info then "INFO"
      when :fail then "FAIL"
      end
      puts "[#{label}] #{text}"
    end
end

class Selenium::WebDriver::Element
  def fill(text)
    $focus = self
    logging :info, "fill #{text}..."
    send_key(text)
  end

  def find(selector)
    find_element(css: selector)
  end

  def finds(selector)
    find_elements(css: selector)
  end

  def to_html
    attribute("outerHTML")
  end

  private
  def logging(sym, text)
    label = case sym
    when :info then "INFO"
    when :fail then "FAIL"
    end
    puts "[#{label}] #{text}"
  end
end
