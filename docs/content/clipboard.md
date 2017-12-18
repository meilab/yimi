### Why
生成密码后，用户需要将密码选择并拷贝，这个操作不是很方便，尤其是使用手机时。所以需要提供一个按键，用户点击后就能拷贝密码。

Elm是函数式编程语言，点击复制的动作本质上一个side effect，需要通过浏览器的API实现。有两种途径：通过Ports或者Elm Native Module的方式，都不是很方便，而且不同浏览器实现起来还存在兼容性问题。

最简单稳妥的方法就是采用[clipboard.js](https://clipboardjs.com/)。

### How
#### 引入clipboard.js
* NPM

``` javascript
npm install clipboard --save
```

* CDN

```html
<script src="dist/clipboard.min.js"></script>
```

#### Elm代码
生成的密码显示在一个`input`内，我们需要为这个`input`指定一个`id`: **generatedpassword**，这样在点击时，就知道拷贝哪里的字符。
然后需要一个`button`，点击之后触发拷贝的动作。这个`button`需要赋值一个`attribute`，包含两个参数，第一个参数为**data-clipboard-target**，第二个参数指定待拷贝文本的元素，这里是一个`id`。`clipboard.js`会根据这个`attribute`，来执行拷贝的动作。

``` elm
input
    [ class [ Input, FinalPass ]
    , readonly True
    , id "generatedpassword"
    , value model.generator.password
    ]
    [ text model.generator.password ]

button
    [ Html.Attributes.class "pure-button pure-button-primary"

    -- clipboard.js will handle the copy to clipboard
    , attribute "data-clipboard-target" "#generatedpassword"
    , id "copybutton"
    ]
    [ text "复制密码" ]
```

#### JavaScript代码
这里的JavaScript部分代码很简单，创建一个对象即可，参数用来制定触发拷贝动作的`button`

``` javascript
var clipboard = new Clipboard("#copybutton")
```

### In the end
我们在写代码，设计API的时候，要尽量追求简单，越简单，潜在的bug越少，系统越稳定。
