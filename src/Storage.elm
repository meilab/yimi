port module Storage exposing (..)

import Types exposing (ServiceRecord)


port saveServices : List ServiceRecord -> Cmd msg


port getServices : String -> Cmd msg
