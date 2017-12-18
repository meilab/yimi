### Why [Brunch](http://brunch.io/)
Elm是函数式前端开发语言，与之配合的最多的是Elixir，一种函数式编程的服务器语言。Elixir的内核是Erlang，由爱立信开发的电信系统使用的语言，由于电信系统本身高并发的特性，使得Erlang，Elixir的对于高并发的支持很不错，其它语言使用共享内存来做并发处理，而Erlang采用Message的方式，使得并发编程简单，可靠，高效。

言归正传，Elixir生态圈内，最成熟的服务器框架是Phoenix，它使用Brunch来作为静态资源和包管理工具，所以我在这里也就使用Brunch而非Webpack作为包管理工具。

使用了几次Brunch之后，觉得相比入其它的工具Brunch的配置很简单，而且是声明式的写法，和函数式编程很搭:)，配合一些插件使用，功能很强大，只需要记住**三条命令**就能实现绝大多数功能：编译，增量编译，source mapping，Hot Reloading等功能。

#### 三条命令（不言自明）
* brunch new
* brunch build
* brunch watch

### Install
系统已经安装NPM的情况下，只需下面一条命令即可使用brunch：

```javascript
npm install -g brunch
```

### Setup
使用Brunch，只需要关注两个文件：修改**`package.json`**添加所需要的lib，添加**`brunch-config.js`**对brunch进行简单的配置即可。

#### package.json
在**`devDependencies`**中添加需要的lib，这里由于我们是一个`Elm`的项目，所以需要添加`elm-brunch`，由于在`PWA`相关的`JavaScript`代码中用到了`ES6`的语法，所以需要引入`babel-brunch`。

这里我们需要三个脚本命令，方便我们进行操作。
* postinstall：用于安装Elm相关的包
* start：用于开发时调试，包含了Local Server，Hot Reloading等功能
* build：用于生产发布，会进行代码压缩等操作

``` javascript
    scripts: {
      postinstall: elm package install -y,
      start: brunch watch --server,
      prod: brunch build --production
    },

    devDependencies: {
      auto-reload-brunch: ^2.7.1,
      babel-brunch: ~6.0.0,
      brunch: ^2.8.2,
      hmr-brunch: ^0.1.1,
      clean-css-brunch: ~2.0.0,
      css-brunch: ~2.0.0,
      elm-brunch: ^0.7.0,
      javascript-brunch: ~2.0.0,
      uglify-js-brunch: ~2.0.1
    },
```

#### brunch-config.js
下面贴出了完成的brunch-config.js文件，很简单，只有40行左右，详细内容请直接看下面代码，其中注释已经标的比较清楚。这里只提几个容易出问题的点：
* babel:这里一定要将vendor文件夹和elm编译生成的js的相关代码忽略掉，否则babel在处理这里时，会浪费很多时间，这里并不需要babel进行转码。尤其是当elm.js大于500kb时，会非常耗时。

* elmBrunch:在开发调试阶段，需要加入`--debug`选项，方便我们进行调试。在production阶段，需要将`debug`等选项去掉
* autoRequire:这里如果不写`app.js`的话，浏览器不会加载Elm。

``` javascript
module.exports = {
  config: {
    paths: {
      // Dependencies and current project directories to watch
      watched: ["src", "static"]
    },
    files: {
      javascripts: {
        joinTo: "js/app.js"
      },
      stylesheets: {
        joinTo: "css/app.css"
      }
    },
    conventions: {
      // This option sets where we should place non-css and non-js assets in.
      // By default, we set this to "/static/assets". Files in this directory
      // will be copied to `paths.public`, which is "priv/static" by default.
      assets: /^(static\/assets)/
    },
    plugins: {
      babel: {
        // Do not use ES6 compiler in vendor code and elm code
        ignore: [/static\/vendor/, /elm.js$/]
      },
      elmBrunch: {
        mainModules: ["src/Main.elm"],
        outputFolder: "static/js/",
        outputFile: "elm.js",
        makeParameters : ['--debug','--warn']
      }
    },
    modules: {
      autoRequire: {
        "js/app.js": ["static/js/app"]
      }
    },
    npm: {
      enabled: true
    },
    overrides: {
       production: {
         plugins: {
           elmBrunch: {
             makeParameters: []
           }
         }
       }
    }
  }
};
```
