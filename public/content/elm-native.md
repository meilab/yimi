需要注意的是，这里所说的`Native`指的是在`Elm`中直接调用的`JavaScript`代码，而不是类似`React Native`所说的为`iOS` / `Android`所写的原生应用，关于使用Elm写`iOS`或者`Android`原生应用，可以关注[Elm Native Ui](https://github.com/ohanhi/elm-native-ui)

需要注意的是：Elm相对于JavaScript的一个非常大的优势是没有run-time error。如果采用了文中所说的Elm Native的方式，Elm调用自己写的JavaScript代码，是有可能引入run-time error的。需要非常小心。

### Elm Native基础
由于需要用到`sjcl`这个JavaScript库中的PBGDF2算法进行密码生成运算，所以需要用到Elm Native的方法。
首先需要在`elm-package.json`中加入**`"native-modules": true,`**，告诉Elm编译器，项目中有Native模块需要编译。
然后我们就可以着手写`JavaScript`部分的代码了，文件一定要放在`Native`目录下。

我们只需要一个`generateKey`函数，接收四个参数，返回一个PBKDF2生成的密码。这部分就是常规的JavaScript编程，定义好函数即可。

我们的最终目的是使得Elm代码可以调用这个函数实现密码生成，如何将这两者联系起来呢？
浏览器本身只支持JavaScript代码，Elm代码也会被Elm编译器最终编译成JavaScript代码来运行，所以这里我们需要做的就是将我们写的Native(JavaScript)代码写成**IIFE**:immediately-invoked function expression。这个IIFE的命名规则必须符合Elm的规矩，以便使得它可以被嵌入到Elm编译生成的JavaScript代码当中。
规则如下：`_[username]$[project name]$[module name]`。这里的`username`和`project name`都是来自于`elm-package.json`中的`repository`，`module name`需要以`Native`开头，这里我们叫`Native_Pbkdf2`，文件保存路径需要和`module name`相关联：`Native/Pbkdf2.js`。

由于`Elm`中的所有函数都是柯理化的(Curried)，所以需要使用Elm提供的`F4`对`generateKey`做一个wrapper，这里使用`F4`是因为函数有四个参数。

``` javascript
var _meilab$elm_wexin_crypto$Native_Pbkdf2 = function() {
  const uuid = "f87eb0f4-31cb-46b9-93ad-261c5ab063e7"

  function generateKey(password, service, count, length) {
    var salt = service + uuid
    var derivedKey = sjcl.misc.pbkdf2(password, salt, count, length)
    var key = sjcl.codec.hex.fromBits(derivedKey)

    return key;
  }

  return {
    generateKey : F4(generateKey)
  }
}()
```

在Elm代码中可以`import`编写的`Native`代码，像如下代码一样使用

```elm
import Native.Pbkdf2 exposing (..)

doGeneratePassword : String -> String -> Int -> PasswordCategory -> String
doGeneratePassword phrase service length pwCategory =
    ...
    key =
        Native.Pbkdf2.generateKey phrase service 3000 (requestPwLength * nDigits)
    ...
```

### Tasks
上文描述的`Native`代码是纯计算，没有**side-effect**，符合Elm纯函数的思想。
编程中有很多都是异步调用(AJAX call, 数据库存取)，这种情况下不能直接调用，需要用到Elm中的Task。

这里使用微信接口举例。这个代码编写了两个版本：网页版和微信小程序版，微信版中，需要使用微信的本地存储功能，这个功能需要调用微信提供的API函数，存储函数是个异步函数。BTW：这个功能本身也可以通过`Ports`的方式来实现。

使用Task时，需要用到`Elm`提供的`_elm_lang$core$Native_Scheduler`，它可以帮助我们管理Task。首先需要使用到的是其`nativeBinding`方法，该方法接收一个函数作为参数，这个函数需要一个callback作为参数，当异步调用结束之后，我们需要调用这个`callback`，根据异步调用的执行情况通过`scheduler.succeed`或者`scheduler.fail`将结果传递回去。
这个例子当中，wx.getStorage是微信提供的存储API，我们将`callback`放在其成功或者失败的回调函数中即可。

```javascript
var _meilab$elm_wexin_crypto$Native_WxApi = function() {
    var scheduler = _elm_lang$core$Native_Scheduler

    function getStorage(key) {
        return scheduler.nativeBinding(function (callback){
            wx.getStorage({
                key: key,
                success: function(res){
                    callback(scheduler.succeed(res.data));
                },
                fail: function(err){
                    callback(scheduler.fail('Get Failed'));
                }
            })
        })
    }

    return {
        getStorage : getStorage,
    }
}()
```

在Elm代码中，我们可以直接使用`Task.perform` 或者 `Task.attempt`。
如果之前没有很少接触Elm这类语言，可以先看一些介绍Task和[Result](https://guide.elm-lang.org/error_handling/result.html)的文章。

```elm
module WxApi exposing (..)

import Native.WxApi
import Task exposing (Task)

getStorage : (Result String a -> msg) -> String -> Cmd msg
getStorage resultToMessage key =
    Task.attempt resultToMessage (Native.WxApi.getStorage key)
```
