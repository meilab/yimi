module Password.Models exposing (..)

import Types exposing (Config, PasswordCategory(..))


type alias PasswordGenerator =
    { primaryKey : String
    , service : String
    , password : String
    , config : Config
    }


initGenerator : PasswordGenerator
initGenerator =
    { primaryKey = ""
    , service = ""
    , config = Config (Just 8) All
    , password = ""
    }
