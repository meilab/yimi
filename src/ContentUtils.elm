module ContentUtils exposing (..)

import Types exposing (Content, ServiceRecord, DisplayMode(..), FolderType(..))
import Time.DateTime as DateTime exposing (fromTimestamp, compare)
import Routing exposing (Route)
import Posts
import Pages
import String


allContent : List Content
allContent =
    Pages.pages ++ Posts.posts


filterByRoute : Route -> List Content -> Maybe Content
filterByRoute route contentList =
    contentList
        |> List.filter (\item -> item.route == route)
        |> List.head


filterByDisplayMode : DisplayMode -> List ServiceRecord -> List ServiceRecord
filterByDisplayMode displayMode serviceList =
    case displayMode of
        FolderSelector folderType ->
            filterByFolder folderType serviceList

        Stared ->
            filterByStarStatus serviceList


filterByFolder : FolderType -> List ServiceRecord -> List ServiceRecord
filterByFolder folderType serviceList =
    case folderType of
        AllFolders ->
            serviceList

        NamedFolder folderName ->
            serviceList
                |> List.filter (\item -> item.folderType == folderName)


filterByStarStatus : List ServiceRecord -> List ServiceRecord
filterByStarStatus serviceList =
    serviceList
        |> List.filter (\item -> item.stared == True)


filterByService : Maybe String -> List ServiceRecord -> List ServiceRecord
filterByService service serviceList =
    case service of
        Just value ->
            serviceList
                |> List.filter
                    (\item ->
                        String.contains (String.toLower value) (String.toLower item.service)
                    )

        Nothing ->
            sortByDate serviceList


filterByTitle : Maybe String -> List Content -> List Content
filterByTitle title contentList =
    case title of
        Just title ->
            contentList
                |> List.filter
                    (\item ->
                        String.contains (String.toLower title) (String.toLower item.title)
                    )

        Nothing ->
            contentList



{-
   latest : List ServiceRecord -> ServiceRecord
   latest =
       sortByDate >> List.head >> Maybe.withDefault Pages.notFoundContent
-}


sortByDate : List ServiceRecord -> List ServiceRecord
sortByDate =
    List.sortWith (flip contentByDateComparison)


contentByDateComparison : ServiceRecord -> ServiceRecord -> Order
contentByDateComparison a b =
    DateTime.compare (fromTimestamp a.time) (fromTimestamp b.time)
