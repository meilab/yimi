module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = HomeRoute
    | GeneratorRoute
    | AboutRoute
    | NavigationRoute
    | ImplementationRoute
    | PostsRoute String
    | AuthorRoute
    | NotFoundRoute


parseBaseUrl : String -> Parser a a -> Parser a a
parseBaseUrl base_url item =
    case base_url of
        "" ->
            item

        _ ->
            base_url
                |> String.dropLeft 1
                |> String.split "/"
                |> List.map (s)
                |> List.reverse
                |> List.foldl (</>) (item)


matchers : String -> Parser (Route -> a) a
matchers base_url =
    oneOf
        [ map HomeRoute (parseBaseUrl base_url top)
        , map GeneratorRoute (parseBaseUrl base_url (s "generator"))
        , map NavigationRoute (parseBaseUrl base_url (s "navigation"))
        , map AboutRoute (parseBaseUrl base_url (s "about"))
        , map ImplementationRoute (parseBaseUrl base_url (s "implementation"))
        , map AuthorRoute (parseBaseUrl base_url (s "author"))

        -- PostsRoute must be the last one, otherwise it will match all cases:)
        , map PostsRoute (parseBaseUrl base_url top </> string)
        ]


parseLocation : Location -> String -> Route
parseLocation location base_url =
    case (parsePath (matchers base_url) location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


urlFor : String -> Route -> String
urlFor base_url route =
    case route of
        HomeRoute ->
            base_url ++ "/"

        GeneratorRoute ->
            base_url ++ "/generator"

        NavigationRoute ->
            base_url ++ "/navigation"

        AboutRoute ->
            base_url ++ "/about"

        ImplementationRoute ->
            base_url ++ "/implementation"

        AuthorRoute ->
            base_url ++ "/author"

        PostsRoute slug ->
            base_url ++ slug

        NotFoundRoute ->
            base_url


routingItem : String -> List ( String, String, Route, String )
routingItem base_url =
    [ ( "Home", "fa fa-home", HomeRoute, base_url ++ "/" )
    , ( "Generator", "fa fa-plus", GeneratorRoute, base_url ++ "/generator" )
    , ( "How It Works", "fa fa-code", AboutRoute, base_url ++ "/about" )
    , ( "Implementatio Details", "fa fa-code", ImplementationRoute, base_url ++ "/implementation" )
    , ( "Author", "fa fa-user", AuthorRoute, base_url ++ "/author" )
    ]


mobileHeaderRoutingItem : String -> List ( String, String, Route, String )
mobileHeaderRoutingItem base_url =
    [ ( "", "fa fa-list-ul", NavigationRoute, base_url ++ "/navigation" )
    , ( "", "fa fa-plus", GeneratorRoute, base_url ++ "/generator" )
    ]


routingButtonHome : String -> ( String, String, Route, String )
routingButtonHome base_url =
    ( "列表", "fa fa-angle-left", HomeRoute, base_url ++ "/" )


routingButtonNavigation : String -> ( String, String, Route, String )
routingButtonNavigation base_url =
    ( "", "fa fa-list-ul", NavigationRoute, base_url ++ "/navigation" )


routingButtonGenerator : String -> ( String, String, Route, String )
routingButtonGenerator base_url =
    ( "", "fa fa-plus", GeneratorRoute, base_url ++ "/generator" )


footerRoutingItem : List ( String, String, String )
footerRoutingItem =
    [ ( "Github", "fa fa-github fa-stack-1x fa-inverse", "https://github.com/meilab" )

    --, ( "Wechat", "fa fa-weixin fa-stack-1x fa-inverse", "https://weixin.com" )
    --, ( "Weibo", "fa fa-weibo fa-stack-1x fa-inverse", "http://weibo.com/meilab" )
    , ( "Linkedin", "fa fa-linkedin fa-stack-1x fa-inverse", "https://linkedin.com/in/meilab" )
    ]
