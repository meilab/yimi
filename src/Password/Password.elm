module Password.Password exposing (..)

import Native.Pbkdf2 exposing (..)
import Password.Utils exposing (..)
import Types exposing (PasswordCategory(..), CharsetCategory(..))
import Array exposing (Array)
import Tuple exposing (first)


lower : List String
lower =
    String.split "" "abcdefghijklmnopqrstuvwxyz"


upper : List String
upper =
    String.split "" "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


alpha : List String
alpha =
    lower ++ upper


numbers : List String
numbers =
    String.split "" "0123456789"


symbol : List String
symbol =
    (String.split "" "!#$%&*,.<=>?@[]^{}")


all : List String
all =
    symbol ++ numbers ++ alpha


doGeneratePassword : String -> String -> Int -> PasswordCategory -> String
doGeneratePassword phrase service length pwCategory =
    let
        ( charset, requiredCategories ) =
            case pwCategory of
                OnlyNumbers ->
                    ( numbers |> Array.fromList, [ Numbers ] )

                NumberAndAlpha ->
                    ( (alpha ++ numbers) |> Array.fromList, [ Numbers, Lower, Upper ] )

                All ->
                    ( all |> Array.fromList, [ Numbers, Lower, Upper, Symbol ] )

        -- use n binary bits to represent one character
        nDigits =
            charset
                |> Array.length
                |> toFloat
                |> logBase 2
                |> ceiling

        requestPwLength =
            case length > 80 of
                True ->
                    length

                False ->
                    80

        key =
            Native.Pbkdf2.generateKey phrase service 3000 (requestPwLength * nDigits)

        password =
            key
                |> hex2bin
                |> strSplit nDigits
                |> List.map bin2Decimal
                |> List.map (charsetEncode (Array.length charset))
                |> List.map
                    (\x ->
                        charset
                            |> Array.get x
                            |> Maybe.withDefault "*"
                    )
                |> selectPw length requiredCategories
                |> String.join ""
    in
        password



{-
   Basically we will generate much more characters in order to have all the
   Categories,
   Truncate the Generated Password until we have all the required Category
   choose the first
-}


selectPw : Int -> List CharsetCategory -> List String -> List String
selectPw length requiredCategories pwList =
    let
        num_of_cate =
            List.length requiredCategories

        free_choice_num =
            length - num_of_cate + 1
    in
        pwList
            |> List.foldl
                (\x ( final, required ) ->
                    let
                        curCategory =
                            findCategory x

                        newRequired =
                            required
                                |> List.filter
                                    (\cate -> (cate /= curCategory))
                    in
                        if (List.length final >= length) then
                            ( final, newRequired )
                        else if
                            ((List.length final)
                                < free_choice_num
                                || (List.isEmpty required)
                                || (List.member curCategory required)
                            )
                        then
                            ( final ++ [ x ], newRequired )
                        else
                            ( final, newRequired )
                )
                ( [], requiredCategories )
            |> first


findCategory : String -> CharsetCategory
findCategory str =
    if (List.member str numbers) then
        Numbers
    else if (List.member str lower) then
        Lower
    else if (List.member str upper) then
        Upper
    else
        Symbol
