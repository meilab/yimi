module Pages exposing (..)

import Types exposing (Content)
import RemoteData exposing (RemoteData)
import Routing exposing (Route(..))
import Time.Date as Date exposing (Date, date)
import Authors


home : Content
home =
    { slug = "/"
    , route = HomeRoute
    , name = "index"
    , title = "About Me: WY"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "Home Page"
    , hero = "images/cover1.jpg"
    }


about : Content
about =
    { slug = "/about"
    , route = AboutRoute
    , name = "about"
    , title = "About this tool"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = "About Page"
    , hero = "images/cover1.jpg"
    }


implementation : Content
implementation =
    { slug = "/implementation"
    , route = ImplementationRoute
    , name = "implementation"
    , title = "Implementation Details"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = ""
    , hero = "images/cover7.jpg"
    }


generator : Content
generator =
    { slug = "/generator"
    , route = GeneratorRoute
    , name = "generator"
    , title = "Generator"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = ""
    , hero = "images/cover1.jpg"
    }


navigation : Content
navigation =
    { slug = "/navigation"
    , route = NavigationRoute
    , name = "navigation"
    , title = "Navigation"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = ""
    , hero = "images/cover1.jpg"
    }


author : Content
author =
    { slug = "/author"
    , route = AuthorRoute
    , name = "author"
    , title = "About Wang Yi"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = ""
    , hero = "images/cover4.jpg"
    }


notFoundContent : Content
notFoundContent =
    { slug = "/notfound"
    , route = NotFoundRoute
    , name = "not-found"
    , title = "Couldn't find content"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = ""
    , hero = "images/cover1.jpg"
    }


notFound404 : Content
notFound404 =
    { slug = "/404"
    , route = NotFoundRoute
    , name = "404"
    , title = "You Are lost"
    , publishedDate = date 2017 12 3
    , author = Authors.wy
    , markdown = RemoteData.NotAsked
    , preview = ""
    , hero = "images/cover1.jpg"
    }


pages : List Content
pages =
    [ home
    , generator
    , navigation
    , about
    , implementation
    , author
    , notFoundContent
    , notFound404
    ]
