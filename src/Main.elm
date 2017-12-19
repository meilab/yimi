port module Main exposing (..)

import Models exposing (..)
import Messages exposing (Msg(..))
import Update exposing (..)
import Views exposing (view)
import Navigation exposing (Location)
import Routing exposing (parseLocation)
import Types exposing (ServiceRecord, OpenDropdown(..))
import Storage exposing (..)
import Time exposing (every, second)
import Task exposing (Task)
import Mouse
import ContentUtils exposing (allContent, filterByRoute)
import Pages


ghProjectName : String
ghProjectName =
    "yimi"


init : Location -> ( Model, Cmd Msg )
init location =
    let
        base_url =
            case
                location.pathname
                    |> String.split "/"
                    |> List.member ghProjectName
            of
                True ->
                    "/" ++ ghProjectName

                False ->
                    ""

        currentRoute =
            parseLocation location base_url

        url =
            { base_url = base_url }

        currentContent =
            allContent
                |> filterByRoute currentRoute
                |> Maybe.withDefault Pages.notFound404

        currentModel =
            initModel currentRoute currentContent url
    in
        ( currentModel
        , Cmd.batch
            [ Task.perform Tick Time.now
            , getServices "service"
            , changeUrlCommand base_url currentRoute currentContent
            ]
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        dragSubs =
            case model.drag of
                Nothing ->
                    if model.openDropDown == AllClosed then
                        []
                    else
                        [ Mouse.clicks (always Blur)
                        ]

                Just _ ->
                    -- Disable Blur during Drag
                    -- cause we need to use Blur to clear offsetServiceOffset after drag
                    [ Mouse.moves DragAt, Mouse.ups DragEnd ]
    in
        Sub.batch
            (dragSubs
                ++ [ receiveServices ReceiveServices
                   , saveServiceSucc SaveServiceSucc
                   , saveServiceFail SaveServiceFail
                   , every (second * 1000) Tick
                   ]
            )


port receiveServices : (List ServiceRecord -> msg) -> Sub msg


port saveServiceSucc : (List ServiceRecord -> msg) -> Sub msg


port saveServiceFail : (String -> msg) -> Sub msg


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
