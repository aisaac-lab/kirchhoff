require 'selenium-webdriver'

class GogoDriver
  class Entity
    attr_reader :driver

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
      has?(selector) ? find(selector).click : false
    end

    def submit
      $focus.submit if $focus
    end
  end
end

class Selenium::WebDriver::Element
  def fill(text)
    $focus = self
    send_key(text)
  end
end
