module Kirchhoff
  module CommonInterface
    def find selector
      e = self.find_element(css: selector).tap do
        Kirchhoff::Logger.call :info, "find #{selector}..."
      end

      block_given? ? yield(e) : e
    rescue Selenium::WebDriver::Error::NoSuchElementError
      nil
    end

    def multi_find selector
      self.find_elements(css: selector).tap do |e|
        Kirchhoff::Logger.call :info, "multi find #{selector}..."
      end
    end

    def find_text text
      e = self.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"}).tap do
        Kirchhoff::Logger.call :info, "find text '#{text}'..."
      end

      block_given? ? yield(e) : e
    rescue Selenium::WebDriver::Error::NoSuchElementError
      nil
    end

    def multi_find_text text
      self.find_elements({xpath: "//*[text()[contains(.,\"#{text}\")]]"}).tap do |e|
        Kirchhoff::Logger.call :info, "multi find text '#{text}'..."
      end
    end

    def to_html
      attribute "outerHTML"
    end

    def to_nokogiri
      Nokogiri::HTML self.to_html
    end
  end
end
