require 'selenium-webdriver'

class GogoDriver
  attr_accessor :__driver__

  def initialize(browser=:chrome)
    @__driver__ = Selenium::WebDriver.for(browser)
  end

  def go(url)
    logging "[VISITE] #{url}..."
    @__driver__.navigate.to(url)
  end

  def reload
    @__driver__.navigate.refresh
  end

  def find(selector)
    logging "[FIND] #{selector}..."
    @__driver__.find_element(css: selector)
  end

  # http://stackoverflow.com/questions/11908249/debugging-element-is-not-clickable-at-point-error
  def scroll(selector)
    logging "[SCROLL] #{selector}..."
    element = find(selector)
    @__driver__.driver.execute_script "window.scrollTo(#{element.location.x},#{element.location.y})"
    element
  end

  def finds(selector)
    @__driver__.find_elements(css: selector)
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
    logging "[CLICK] #{selector}..."
    has?(selector) ? find(selector).click : false
  end

  def submit
    logging "[SUBMIT] ..."
    $focus.submit if $focus
  end

  def save_html(file_path)
    File.open(file_path, 'w') { |f| f.write(@__driver__.page_source) }
  end

  def method_missing(method, *args, &block)
    @__driver__.respond_to?(method) ? @__driver__.send(method, *args, &block) : super
  end

  private
    def logging(text)
      puts text
    end
end

class Selenium::WebDriver::Element
  def fill(text)
    $focus = self
    "[FILL] #{text}..."
    send_key(text)
  end

  def find(selector)
    find_element(css: selector)
  end

  def finds(selector)
    find_elements(css: selector)
  end

  private
    def logging(text)
      puts text
    end
end
