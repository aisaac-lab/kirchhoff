require 'selenium-webdriver'

class GogoDriver
  attr_accessor :driver

  def initialize
    @driver = Selenium::WebDriver.for(:chrome)
  end

  def go(url)
    @driver.navigate.to(url)
  end

  def reload
    @driver.navigate.refresh
  end

  def find(selector)
    @driver.find_element(css: selector)
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
    has?(selector) ? find(selector).click : false
  end

  def submit
    $focus.submit if $focus
  end

  def method_missing(method, *args, &block)
    @driver.respond_to?(method) ? @driver.send(method, *args, &block) : super
  end
end
