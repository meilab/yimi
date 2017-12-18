module Models exposing (..)

import Types
    exposing
        ( ServiceRecord
        , Content
        , Config
        , PasswordCategory(..)
        , FolderType(..)
        , DisplayMode(..)
        , OpenDropdown(..)
        , Drag
        , ServiceItemOffset
        )
import Routing exposing (Route)
import Password.Models exposing (PasswordGenerator, initGenerator)
import Time exposing (Time)


dragOffsetThresh : Int
dragOffsetThresh =
    60


type alias Url =
    { base_url : String }


type alias Ui =
    { folderListActive : Bool }


type alias Model =
    { route : Route
    , url : Url
    , ui : Ui
    , currentContent : Content
    , generator : PasswordGenerator
    , selectedFolder : FolderType
    , stared : Bool
    , currentTime : Time
    , defaultConfig : Config
    , savedServices : List ServiceRecord
    , folders : List String
    , displayMode : DisplayMode
    , serviceFilter : Maybe String
    , openDropDown : OpenDropdown
    , dropdownFolderList : Maybe String
    , drag : Maybe Drag
    , serviceItemOffset : Maybe ServiceItemOffset
    , titleFilter : Maybe String
    }


initDefaultConfig : Config
initDefaultConfig =
    Config (Just 8) All


initModel : Route -> Content -> Url -> Model
initModel route content url =
    { route = route
    , url = url
    , ui = Ui False
    , currentContent = content
    , generator = initGenerator
    , selectedFolder = AllFolders
    , stared = False
    , currentTime = 0.0
    , defaultConfig = initDefaultConfig
    , savedServices = []
    , folders = [ "Life", "Work" ]
    , displayMode = FolderSelector AllFolders
    , serviceFilter = Nothing
    , openDropDown = AllClosed
    , dropdownFolderList = Nothing
    , drag = Nothing
    , serviceItemOffset = Nothing
    , titleFilter = Nothing
    }
