module Messages exposing (..)

import Password.Messages exposing (PasswordMsg(..))
import Types exposing (OpenDropdown, FolderType, DisplayMode, ServiceRecord, Config, ConfigToJs)
import Time exposing (Time)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Mouse exposing (Position)


type Msg
    = PasswordMsg PasswordMsg
    | OnLocationChange Location
    | NewUrl String
    | Backward
    | FetchedContent (WebData String)
    | ToggleFolderList
    | Toggle OpenDropdown
    | DisplayModeSelected DisplayMode
    | FolderSelected FolderType
    | Blur
    | ToggleStarStatus
    | SaveDefaultConfig Config
    | ClearService
    | SaveService
      -- OnTime is after SaveService, because get time is a command in Elm
    | OnTime Time
    | SaveServiceSucc (List ServiceRecord)
    | SaveServiceFail String
    | SelectService ServiceRecord
    | DeleteService String
      -- Searcher
    | UpdateServiceFilter String
      -- Storage LocalForage
    | GetServices
    | ReceiveServices (List ServiceRecord)
    | Tick Time
    | DragStart String Position
    | DragAt Position
    | DragEnd Position
    | NoOp
