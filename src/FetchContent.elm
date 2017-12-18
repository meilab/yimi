module FetchContent exposing (..)

import Types exposing (Content)
import Messages exposing (Msg(..))
import Http
import RemoteData


fetch : Content -> String -> Cmd Msg
fetch content base_url =
    Http.getString (locForContent content base_url)
        |> Http.toTask
        |> RemoteData.asCmd
        |> Cmd.map FetchedContent


locForContent : Content -> String -> String
locForContent content base_url =
    base_url ++ "/content/" ++ content.name ++ ".md"
