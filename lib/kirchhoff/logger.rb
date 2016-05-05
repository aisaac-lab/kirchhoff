module Kirchhoff
  module Logger
    ANSI_CODES = {
      :red    => 31,
      :green  => 32,
      :yellow => 33,
      :blue   => 34,
      :gray   => 90
    }.freeze

    class << self
      def call(sym, text)
        label = case sym
        when :info then blue("INFO")
        when :fail then red("FAIL")
        end
        puts "[#{label}] #{text}"
      end

      private
        Kirchhoff::Logger::ANSI_CODES.each do |name, code|
          define_method(name) do |string|
            "\e[0;#{code};49m#{string}\e[0m"
          end
        end
    end
  end
end
