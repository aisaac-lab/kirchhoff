# GogoDriver

Super simple web driver.

## Installation

1. Install gem as you like. 

    $ gem install gogo_driver
    
2. Install chromedriver. Below is the MacOS example.

    $ brew install chromedriver


## Demo

Let me show how to login Facebook.

```
require 'gogo_driver'
include GogoDriver

go('https://www.facebook.com/')

find('input#email').fill('mail@gogotanaka.com')

find('input#pass').fill('password')

submit

if driver.has_text?('メールアドレスが正しくありません')
  # ログインエラー後の処理
else
  # ログイン成功時の処理
end
```
