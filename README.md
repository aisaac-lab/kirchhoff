# Smart Driver

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

driver = Kirchhoff::Driver.new
driver.go 'https://www.facebook.com/'
driver.find('input#email').fill('mail@gogotanaka.com')
driver.find('input#pass').fill('password')
driver.submit

driver.find_text('メールアドレスが正しくありません') do |e|
  unless e
    # If there is no text 'メールアドレスが正しくありません'
  end
end

driver.wait_element("div#wait", timeout: 5)

driver.wait_text("wait for you...", timeout: 5, maybe: false)
#=> raise err if there is no text 'wait for you...'
```
