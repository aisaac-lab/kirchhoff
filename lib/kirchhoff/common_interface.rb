module Kirchhoff
  module CommonInterface
    def find(selector)
      self.find_element(css: selector).tap do |e|
        logging :info, "find #{selector}..."
        yield(e) if block_given?
      end
    end

    def finds(selector)
      self.find_elements(css: selector).tap do |es|
        logging :info, "finds #{selector}..."
      end
    end

    def find_text(text)
      self.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"}).tap do |e|
        logging :info, "find text '#{text}'..."
        yield(e) if block_given?
      end
    end

    def finds_text(text)
      self.find_elements({xpath: "//*[text()[contains(.,\"#{text}\")]]"}).tap do |es|
        logging :info, "finds text '#{text}'..."
      end
    end

    def has?(selector)
      self.find_element(css: selector)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end

    def has_text?(text)
      self.find_element({xpath: "//*[text()[contains(.,\"#{text}\")]]"})
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
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
