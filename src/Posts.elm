module Posts exposing (..)

import Types exposing (Content)
import Time.Date as Date exposing (Date, date)
import RemoteData exposing (RemoteData)
import Routing exposing (Route(..))
import Authors


algorithm : Content
algorithm =
    { slug = "/algorithm"
    , route = PostsRoute "algorithm"
    , title = "算法"
    , name = "algorithm"
    , publishedDate = date 2017 12 4
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "The algorithm used in this tool"
    , hero = "images/cover4.jpg"
    }


clipboard : Content
clipboard =
    { slug = "/clipboard"
    , route = PostsRoute "clipboard"
    , title = "点击复制功能添加"
    , name = "clipboard"
    , publishedDate = date 2017 12 10
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "点击复制功能"
    , hero = "images/cover4.jpg"
    }


brunch : Content
brunch =
    { slug = "/brunch"
    , route = PostsRoute "brunch"
    , title = "Elm中使用Brunch"
    , name = "brunch"
    , publishedDate = date 2017 12 10
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "使用Brunch可以方便快捷的进行包管理"
    , hero = "images/cover4.jpg"
    }


elmNative : Content
elmNative =
    { slug = "/elm-native"
    , route = PostsRoute "elm-native"
    , title = "Elm Native"
    , name = "elm-native"
    , publishedDate = date 2017 12 14
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "单纯使用Elm无法完成某项功能时，有两种选择，Ports和Native代码。这里的Native指的是Elm调用JavaScript写的代码"
    , hero = "images/elm_native.png"
    }


impossibleStates : Content
impossibleStates =
    { slug = "/making-impossible-states-impossible"
    , route = PostsRoute "make-impossible-states-impossible"
    , title = "使用Union Types规避错误状态"
    , name = "making-impossible-states-impossible"
    , publishedDate = date 2017 12 18
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "使用Union Types可以帮助我们很好的限定系统可能发生的状态，从数据结构的角度规避不可能发生的状态"
    , hero = "images/cover4.png"
    }


githubPages : Content
githubPages =
    { slug = "/github-pages"
    , route = PostsRoute "github-pages"
    , title = "使用Github Pages来提供静态网页服务"
    , name = "github-pages"
    , publishedDate = date 2017 12 20
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "Github Pages支持用户通过软件仓库创建静态网站或静态博客，我们只需要将网站的代码上传，github.io就会为我们提供静态网页服务，非常方便"
    , hero = "images/cover4.png"
    }


posts : List Content
posts =
    [ algorithm
    , clipboard
    , brunch
    , elmNative
    , impossibleStates
    , githubPages
    ]
