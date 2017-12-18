module Password.Messages exposing (..)

import Types exposing (ServiceRecord, PasswordCategory)


type PasswordMsg
    = PrimaryKeyInput String
    | ServiceInput String
    | PwLengthInput String
    | PwCategoryChange PasswordCategory
