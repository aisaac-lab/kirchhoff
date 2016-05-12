# Kirchhoff

Smart selenium base web driver written in Ruby.

[![Gyazo](http://i.gyazo.com/511b5265c67d41fc2cd7394c1eee3b7a.gif)](http://gyazo.com/511b5265c67d41fc2cd7394c1eee3b7a)

## Installation

1. Install gem as you like.

  $ gem install kirchhoff

2. Install chromedriver. (Below is the MacOS example.)

  $ brew install chromedriver


## Demo

```rb
require 'kirchhoff'

driver = Kirchhoff::Driver.new(timeout: 1)

driver.go("http://gogotanaka.me/")

driver.find("div#exist", wait: true, maybe: false) do |e|
  # This code is executed.
  e.click
  e.fill("hogehoge")
  p e.to_html
end

driver.find("div#no-exist", wait: true) do |e|
  # This code is not executed.
end

driver.find("div#exist", &:click)&.find("div#inner", maybe: false, &:fill)

# maybe ... raise error when element cannot be found and maybe==true
```
