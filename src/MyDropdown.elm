module MyDropdown exposing (Context, Config, view)

{- a Dropdown component that manages its own state -}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode as JD
import Html.CssHelpers exposing (withNamespace)
import Styles.SharedStyles exposing (..)
import ViewHelpers exposing (navigationOnClick)


{ id, class, classList } =
    withNamespace ""



-- MODEL
{- Context type alias
   this is dynamic stuff - may change in each update cylce
   this is not managed by the dropdown, but passed in from parent
   kind of like props (including callbacks) in react
-}


type alias Context =
    { selectedItem : Maybe String
    , isOpen : Bool
    }



{- Config is the static stuff, that won't change during life cylce
   Like functions and message constructors
   Also transparent, because this is also owned by parent
-}


type alias Config msg =
    { defaultText : String
    , withBorder : Bool
    , clickedMsg : msg
    }



-- VIEW


view : Config msg -> Context -> List ( String, Int, msg ) -> Html msg
view config context data =
    let
        mainText =
            context.selectedItem
                |> Maybe.withDefault config.defaultText

        displayStyle =
            if context.isOpen then
                [ ( "display", "block" ) ]
            else
                [ ( "display", "none" ) ]

        inputClass =
            case config.withBorder of
                True ->
                    DropdownInputWithBorder

                False ->
                    DropdownInput

        mainAttr =
            case data of
                [] ->
                    [ class [ DropdownDisabled, inputClass ]
                    ]

                _ ->
                    [ class [ inputClass ]
                    , onClick config.clickedMsg
                    ]
    in
        div
            [ class [ DropdownContainer ] ]
            [ p
                mainAttr
                [ span [ class [ DropdownText ] ] [ text mainText ]
                , span [] [ text "▾" ]
                ]
            , ul
                [ style <| displayStyle
                , class [ DropdownList ]
                ]
                (dropdownArrow :: List.map (viewItem config context.selectedItem) data)
            ]


dropdownArrow : Html msg
dropdownArrow =
    span [ class [ Arrow ] ] []


viewItem : Config msg -> Maybe String -> ( String, Int, msg ) -> Html msg
viewItem config selectedItem ( str, count, msg ) =
    let
        checkedIcon =
            case (selectedItem == Just str) of
                True ->
                    "fa fa-check"

                False ->
                    ""
    in
        li
            [ class [ DropdownListItem ]
            , onClick <| msg
            ]
            [ text (str ++ " " ++ (toString count))
            , i [ Html.Attributes.class checkedIcon ] []
            ]



-- helper to cancel click anywhere


onClick : msg -> Attribute msg
onClick message =
    navigationOnClick message
