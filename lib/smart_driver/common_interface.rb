class SmartDriver
  module CommonInterface
    def find(selector)
      logging :info, "find #{selector}..."
      self.find_element(css: selector)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      logging :fail, "#{selector} cannot be found..."
      nil
    end

    def finds(selector)
      logging :info, "finds #{selector}..."
      self.find_elements(css: selector)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      logging :fail, "#{selector} cannot be found..."
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
end
