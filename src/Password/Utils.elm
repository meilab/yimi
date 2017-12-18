module Password.Utils exposing (..)

import Dict exposing (Dict)
import Tuple exposing (first)
import Types exposing (..)


hex2binMapping : Dict String String
hex2binMapping =
    Dict.fromList
        [ ( "0", "0000" )
        , ( "1", "0001" )
        , ( "2", "0010" )
        , ( "3", "0011" )
        , ( "4", "0100" )
        , ( "5", "0101" )
        , ( "6", "0110" )
        , ( "7", "0111" )
        , ( "8", "1000" )
        , ( "9", "1001" )
        , ( "a", "1010" )
        , ( "b", "1011" )
        , ( "c", "1100" )
        , ( "d", "1101" )
        , ( "e", "1110" )
        , ( "f", "1111" )
        , ( "A", "1010" )
        , ( "B", "1011" )
        , ( "C", "1100" )
        , ( "D", "1101" )
        , ( "E", "1110" )
        , ( "F", "1111" )
        ]


converter : String -> String
converter hexNum =
    hex2binMapping
        |> Dict.get hexNum
        |> Maybe.withDefault "0000"


hex2bin : String -> String
hex2bin str =
    str
        |> String.split ""
        |> List.map converter
        |> String.join ""


bin2Decimal : String -> Int
bin2Decimal str =
    str
        |> String.split ""
        |> List.foldl
            (\x acc ->
                (x
                    |> String.toInt
                    |> Result.withDefault 0
                )
                    + 2
                    * acc
            )
            0


strSplit : Int -> String -> List String
strSplit nDigits str =
    str
        |> String.split ""
        |> List.foldl
            (\x ( final, accu ) ->
                case (String.length accu) >= nDigits of
                    True ->
                        ( final ++ [ accu ], x )

                    False ->
                        ( final, accu ++ x )
            )
            ( [], "" )
        |> first


charsetEncode : Int -> Int -> Int
charsetEncode length num =
    num % length


stringToPwCategory : String -> PasswordCategory
stringToPwCategory str =
    case str of
        "OnlyNumbers" ->
            OnlyNumbers

        "NumberAndAlpha" ->
            NumberAndAlpha

        _ ->
            All


elmConfig2JsConfig : Config -> ConfigToJs
elmConfig2JsConfig config =
    { config
        | category = toString config.category
        , length = Maybe.withDefault 8 config.length
    }


jsConfig2ElmConfig : ConfigToJs -> Config
jsConfig2ElmConfig config =
    { config
        | category = stringToPwCategory config.category
        , length = Just config.length
    }
