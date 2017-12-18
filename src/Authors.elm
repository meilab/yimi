module Authors exposing (..)

import Types exposing (Author)


wy : Author
wy =
    { name = "Wang Yi"
    , avator = "/image/wy.png"
    , email = "linucywang@aliyun.com"
    , bio = "Coder"
    , blog = "https://meilab.github.io/elm_blog/"
    , location = "Xi'an"
    , github = "https://github.com/meilab/"
    }


authors : List Author
authors =
    [ wy ]
