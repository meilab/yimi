module Password.Update exposing (..)

import Password.Models exposing (..)
import Password.Messages exposing (PasswordMsg(..))
import Password.Password exposing (..)
import Types exposing (ModelToJs, PasswordCategory(..))


generatePassword : String -> String -> Maybe Int -> PasswordCategory -> String
generatePassword primaryKey service length category =
    case (primaryKey == "" || service == "" || length == Nothing) of
        True ->
            ""

        _ ->
            doGeneratePassword primaryKey service (Maybe.withDefault 0 length) category


update : PasswordMsg -> PasswordGenerator -> ( PasswordGenerator, Cmd PasswordMsg )
update msg model =
    case msg of
        PrimaryKeyInput primaryKey ->
            let
                password =
                    generatePassword
                        primaryKey
                        model.service
                        model.config.length
                        model.config.category

                newModel =
                    { model | primaryKey = primaryKey, password = password }
            in
                ( newModel, Cmd.none )

        ServiceInput service ->
            let
                password =
                    generatePassword
                        model.primaryKey
                        service
                        model.config.length
                        model.config.category

                newModel =
                    { model | service = service, password = password }
            in
                ( newModel, Cmd.none )

        PwLengthInput value ->
            let
                config =
                    model.config

                len =
                    case String.toInt value of
                        Ok num ->
                            Just num

                        Err error ->
                            Nothing

                newConfig =
                    { config | length = len }

                password =
                    generatePassword
                        model.primaryKey
                        model.service
                        len
                        model.config.category

                newModel =
                    { model | config = newConfig, password = password }
            in
                ( newModel, Cmd.none )

        PwCategoryChange newCategory ->
            let
                config =
                    model.config

                newConfig =
                    { config | category = newCategory }

                password =
                    generatePassword
                        model.primaryKey
                        model.service
                        model.config.length
                        newCategory

                newModel =
                    { model | config = newConfig, password = password }
            in
                ( newModel, Cmd.none )
