module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, href)
import Messages exposing (Msg(..))
import Routing exposing (Route, routingItem, mobileHeaderRoutingItem, urlFor)
import Html.Events exposing (onWithOptions, on)
import Json.Decode as JD
import Models exposing (Model)
import Html.CssHelpers exposing (withNamespace)
import Styles.SharedStyles exposing (..)
import Time exposing (Time)
import Time.DateTime as DateTime exposing (addHours, fromTimestamp)
import Time.Date as Date exposing (Date)
import Navigation
import Mouse exposing (Position)


{ id, class, classList } =
    withNamespace ""


navigationOnClick : msg -> Attribute msg
navigationOnClick message =
    onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (JD.succeed message)


navigation : Model -> Attribute Msg -> Attribute Msg -> Html Msg
navigation model navClass menuClass =
    nav [ navClass ]
        [ ul [ menuClass ]
            (List.map (navItem model) (routingItem model.url.base_url))
        ]


navItem : Model -> ( String, String, Route, String ) -> Html Msg
navItem model ( title, iconUrl, route, slug ) =
    let
        isCurrentLocation =
            model.route == route

        ( onClickCmd, selectedClass ) =
            case ( isCurrentLocation, route ) of
                ( False, route ) ->
                    ( route |> (urlFor model.url.base_url) |> NewUrl
                    , class []
                    )

                _ ->
                    ( NoOp
                    , class [ MenuSelected ]
                    )
    in
        linkItem selectedClass
            onClickCmd
            (class [])
            iconUrl
            slug
            title


navBack : Html Msg
navBack =
    linkItem (class [])
        Backward
        (class [])
        "fa fa-angle-left"
        ""
        "返回"


linkItem : Attribute Msg -> Msg -> Attribute Msg -> String -> String -> String -> Html Msg
linkItem liClass onClickCmd aClass iconClass slug textToShow =
    li
        [ class [ MenuItem ]
        , liClass
        ]
        [ a
            [ href slug
            , navigationOnClick (onClickCmd)
            , aClass
            ]
            [ --img [ src iconUrl ] []
              i [ Html.Attributes.class iconClass ] []
            , span [] [ text (" " ++ textToShow) ]
            ]
        ]


normalLinkItem : String -> String -> String -> Html Msg
normalLinkItem base_url slug textToShow =
    linkItem (class [])
        (NewUrl (base_url ++ slug))
        (class [])
        ""
        slug
        textToShow


externalLink : String -> String -> Html Msg
externalLink url textToShow =
    a
        [ class [ MenuLink ]
        , href url
        ]
        [ text textToShow ]


footerLinkItem : ( String, String, String ) -> Html Msg
footerLinkItem ( _, iconClass, slug ) =
    li [ class [ MenuItem ] ]
        [ a
            [ href slug ]
            [ span [ Html.Attributes.class "fa-stack fa-lg" ]
                [ i [ Html.Attributes.class "fa fa-circle fa-stack-2x" ] []
                , i [ Html.Attributes.class iconClass ] []
                ]
            ]
        ]


onMouseDown : String -> Attribute Msg
onMouseDown serviceName =
    on "mousedown" (JD.map (DragStart serviceName) Mouse.position)


formatTime : Time.Time -> String
formatTime time =
    time
        |> fromTimestamp
        |> addHours 8
        |> DateTime.toISO8601


formatDate : Date -> String
formatDate date =
    date
        |> Date.toISO8601


displayTime : Time.Time -> String
displayTime time =
    let
        date =
            time
                |> fromTimestamp
                |> addHours 8
    in
        (DateTime.month date |> toString)
            ++ "月"
            ++ (DateTime.day date |> toString |> String.padLeft 2 '0')
            ++ "日 "
            ++ (DateTime.hour date |> toString |> String.padLeft 2 '0')
            ++ ":"
            ++ (DateTime.minute date |> toString |> String.padLeft 2 '0')
