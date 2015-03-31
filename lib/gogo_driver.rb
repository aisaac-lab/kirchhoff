require 'selenium-webdriver'

class GogoDriver
  attr_accessor :driver

  def initialize(browser=:chrome)
    @driver = Selenium::WebDriver.for(browser)
  end

  def go(url)
    logging "[VISITE] #{url}..."
    @driver.navigate.to(url)
  end

  def reload
    @driver.navigate.refresh
  end

  def find(selector)
    logging "[FIND] #{selector}..."
    @driver.find_element(css: selector)
  end

  # http://stackoverflow.com/questions/11908249/debugging-element-is-not-clickable-at-point-error
  def scroll(selector)
    logging "[SCROLL] #{selector}..."
    element = find(selector)
    @driver.driver.execute_script "window.scrollTo(#{element.location.x},#{element.location.y})"
    element
  end

  def finds(selector)
    @driver.find_elements(css: selector)
  end

  def has?(selector)
    !!find(selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def has_text?(text)
    !!@driver.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
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

  def method_missing(method, *args, &block)
    @driver.respond_to?(method) ? @driver.send(method, *args, &block) : super
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
