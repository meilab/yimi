module Types exposing (..)

import Time exposing (Time)
import Time.Date as Date exposing (Date)
import Routing exposing (Route)
import RemoteData exposing (WebData)
import Mouse exposing (Position)


type PasswordCategory
    = OnlyNumbers
    | NumberAndAlpha
    | All


type CharsetCategory
    = Lower
    | Upper
    | Numbers
    | Symbol


type FolderType
    = AllFolders
    | NamedFolder String


type DisplayMode
    = FolderSelector FolderType
    | Stared


type OpenDropdown
    = AllClosed
    | FolderListOpen
    | FolderTransferOpen


type alias ServiceRecord =
    { -- service act as ID for reference
      service : String
    , time : Time
    , config : ConfigToJs
    , stared : Bool
    , folderType : String
    }


type alias ModelToJs =
    { password : String
    , config : ConfigToJs
    , notes : String
    , savedServices : List ServiceRecord
    , defaultConfig : ConfigToJs
    }


type alias Config =
    { length : Maybe Int
    , category : PasswordCategory
    }


type alias ConfigToJs =
    { length : Int
    , category : String
    }


type alias Content =
    { title : String
    , name : String
    , slug : String
    , route : Route
    , publishedDate : Date
    , author : Author
    , preview : String
    , markdown : WebData String
    , hero : String
    }


type alias Drag =
    { start : Position
    , current : Position
    }


type alias ServiceItemOffset =
    { name : String
    , offset : Int
    }


type alias Author =
    { name : String
    , avator : String
    , email : String
    , bio : String
    , blog : String
    , location : String
    , github : String
    }
