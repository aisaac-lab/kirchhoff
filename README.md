# Smart Driver

Smart selenium base web driver written in Ruby.

[![Gyazo](http://i.gyazo.com/511b5265c67d41fc2cd7394c1eee3b7a.gif)](http://gyazo.com/511b5265c67d41fc2cd7394c1eee3b7a)

## Installation

1. Install gem as you like.

    $ gem install smart_driver

2. Install chromedriver. (Below is the MacOS example.)

    $ brew install chromedriver


## Demo

```rb
require 'smart_driver'

driver = SmartDriver.new('https://www.facebook.com/')
driver.find('input#email').fill('mail@gogotanaka.com')
driver.find('input#pass').fill('password')
driver.submit

if driver.has_text?('メールアドレスが正しくありません')
  # ログインエラー後の処理
else
  # ログイン成功時の処理
end
```
