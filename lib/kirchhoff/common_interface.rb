module Kirchhoff
  module CommonInterface
    def find selector, maybe: true, wait: true
      e = wait ? self.waiter.until { weak_find(selector) } : weak_find(selector)

      Kirchhoff::Logger.call :info, "find #{selector}..."

      block_given? ? yield(e) : e
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::TimeOutError
      unless maybe
        raise Selenium::WebDriver::Error::NoSuchElementError, "selector: #{selector}"
      end
    end

    def multi_find selector
      weak_multi_find(selector).tap do
        Kirchhoff::Logger.call :info, "multi find #{selector}..."
      end
    end

    def find_text text, maybe: true, wait: true
      e = wait ? self.waiter.until { weak_find_text(text) } : weak_find_text(text)

      Kirchhoff::Logger.call :info, "find text '#{text}'..."

      block_given? ? yield(e) : e
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::TimeOutError
      unless maybe
        raise Selenium::WebDriver::Error::NoSuchElementError, "text: #{text}"
      end
    end

    def multi_find_text text
      weak_multi_find_text(text).tap do
        Kirchhoff::Logger.call :info, "multi find text '#{text}'..."
      end
    end

    def to_nokogiri
      Nokogiri::HTML self.to_html
    end
  end
end
