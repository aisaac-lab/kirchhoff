# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kirchhoff/version'

Gem::Specification.new do |spec|
  spec.name          = "kirchhoff"
  spec.version       = Kirchhoff::VERSION
  spec.authors       = ["gogotanaka"]
  spec.email         = ["mail@tanakakazuki.com"]

  spec.summary       = %q{Smart selenium base web driver written in Ruby.}
  spec.description   = %q{Smart selenium base web driver written in Ruby.}
  spec.homepage      = "http://aisaac.in"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = "kirchhoff"
  spec.require_paths = ["lib"]

  spec.add_dependency "selenium-webdriver"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
