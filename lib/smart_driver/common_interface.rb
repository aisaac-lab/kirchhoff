class SmartDriver
  module CommonInterface
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
