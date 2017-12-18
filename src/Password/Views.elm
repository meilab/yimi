module Password.Views exposing (generatorForm)

import Password.Messages exposing (PasswordMsg(..))
import Password.Models exposing (..)
import Html exposing (Html, fieldset, text, div, input, label)
import Html.Attributes exposing (src, type_, checked, value, href, seamless, width, height, placeholder)
import Html.Events exposing (onInput, onClick)
import Html.CssHelpers exposing (withNamespace)
import Styles.SharedStyles exposing (..)
import Types exposing (PasswordCategory(..))


{ id, class, classList } =
    withNamespace ""


checkbox : PasswordMsg -> PasswordCategory -> String -> Html PasswordMsg
checkbox msg currentCategory name =
    let
        category =
            case msg of
                PwCategoryChange category ->
                    category

                _ ->
                    All

        checkedStatus =
            category == currentCategory
    in
        label
            [ class [ CategorySelector ] ]
            [ input
                [ type_ "checkbox"
                , checked checkedStatus
                , onClick msg
                ]
                []
            , text name
            ]


generatorForm : PasswordGenerator -> Html PasswordMsg
generatorForm generator =
    let
        length =
            case generator.config.length of
                Nothing ->
                    ""

                Just num ->
                    toString num
    in
        div [ class [ GeneratorFormContainer ] ]
            [ div [ class [ GeneratorFormItem ] ]
                [ label [] [ text "主密钥" ]
                , input
                    [ onInput PrimaryKeyInput
                    , class [ Input ]
                    , value generator.primaryKey
                    , type_ "password"
                    ]
                    []
                ]
            , div [ class [ GeneratorFormItem ] ]
                [ label [] [ text "服务名(例如：taotao)" ]
                , input
                    [ onInput ServiceInput
                    , class [ Input ]
                    , value generator.service
                    ]
                    []
                ]
            , div [ class [ GeneratorFormItem ] ]
                [ label [] [ text "密码长度" ]
                , input
                    [ onInput PwLengthInput
                    , class [ Input ]
                    , value length
                    , type_ "number"
                    ]
                    []
                ]
            , div [ class [ GeneratorContainer ] ]
                [ div [ class [ CategorySelectorContainer ] ]
                    [ checkbox (PwCategoryChange All) generator.config.category "高强度"
                    , checkbox (PwCategoryChange NumberAndAlpha) generator.config.category "字母+数字"
                    , checkbox (PwCategoryChange OnlyNumbers) generator.config.category "纯数字"
                    ]
                ]
            ]
