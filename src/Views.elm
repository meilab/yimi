module Views exposing (view)

import Messages exposing (Msg(..))
import Models exposing (..)
import Html exposing (Html, ul, p, footer, iframe, article, img, h1, h2, a, i, text, div, input, label, button)
import Html.Attributes exposing (attribute, class, src, href, value, readonly, seamless, width, height, placeholder)
import Html.Events exposing (onInput, onClick)
import Html.CssHelpers exposing (withNamespace)
import Css exposing (backgroundImage, url, marginLeft, px)
import Styles.SharedStyles exposing (..)
import Password.Views exposing (generatorForm)
import Routing
    exposing
        ( Route(..)
        , routingButtonNavigation
        , routingButtonGenerator
        , routingButtonHome
        , footerRoutingItem
        )
import ViewHelpers exposing (..)
import Types
    exposing
        ( Content
        , OpenDropdown(..)
        , ServiceRecord
        , DisplayMode(..)
        , FolderType(..)
        , Drag
        , ServiceItemOffset
        )
import ContentUtils exposing (..)
import MyDropdown as Dropdown
import Markdown
import RemoteData exposing (WebData, RemoteData(..))
import Posts exposing (posts)


{ id, class, classList } =
    withNamespace ""


styles =
    Css.asPairs >> Html.Attributes.style


view : Model -> Html Msg
view model =
    let
        contentView =
            case model.route of
                HomeRoute ->
                    homeView model

                GeneratorRoute ->
                    generatorView model

                NavigationRoute ->
                    navigationView model

                AboutRoute ->
                    renderInfoPage model

                ImplementationRoute ->
                    renderInfoPage model

                PostsRoute slug ->
                    renderInfoPage model

                AuthorRoute ->
                    renderInfoPage model

                _ ->
                    notFoundView
    in
        contentView


homeView : Model -> Html Msg
homeView model =
    div [ class [ Layout ] ]
        [ homeHeaderNav model
        , div
            [ class [ ContentContainer ]
            , styles
                [ backgroundImage (url "images/cloud_note_bg_d2def91e10.jpg")
                ]
            ]
            [ div [ class [ SearchBar ] ]
                [ div [ class [ SearchIcon ] ]
                    [ i [ Html.Attributes.class "fa fa-search" ] [] ]
                , input
                    [ class [ Searcher ]
                    , placeholder "快速搜索关键字"
                    , onInput UpdateServiceFilter
                    ]
                    []
                , div [ class [ SearchClear ] ] []
                ]
            , serviceListView model.displayMode model.serviceFilter model.serviceItemOffset model.savedServices
            ]
        ]


folderListDropdownConfig : Dropdown.Config Msg
folderListDropdownConfig =
    { defaultText = "-- pick a country --"
    , withBorder = False
    , clickedMsg = Toggle FolderListOpen
    }


homeHeaderNav : Model -> Html Msg
homeHeaderNav model =
    let
        folderName =
            case model.displayMode of
                FolderSelector AllFolders ->
                    "全部密码"

                FolderSelector (NamedFolder name) ->
                    name

                Stared ->
                    "加星密码"

        context =
            { selectedItem = Just folderName
            , isOpen = model.openDropDown == FolderListOpen
            }
    in
        div [ class [ HeaderNavWrapper ] ]
            [ div [ class [ HeaderNavContainer ] ]
                [ navItem model (routingButtonNavigation model.url.base_url)
                , Dropdown.view
                    folderListDropdownConfig
                    context
                    (folderListItems model.folders model.savedServices)
                , navItem model (routingButtonGenerator model.url.base_url)
                ]
            ]


generatorHeaderNav : Model -> Html Msg
generatorHeaderNav model =
    div [ class [ HeaderNavWrapper ] ]
        [ div [ class [ HeaderNavContainer ] ]
            [ navItem model (routingButtonHome model.url.base_url)
            , div [ onClick ToggleFolderList ] [ text "Generator" ]
            , div
                [ class [ MenuItem ]
                , onClick SaveService
                ]
                [ a [] [ i [ Html.Attributes.class "fa fa-check" ] [] ]
                ]
            ]
        ]


navigationHeaderNav : Model -> Html Msg
navigationHeaderNav model =
    div [ class [ HeaderNavWrapper ] ]
        [ div [ class [ HeaderNavContainer ] ]
            [ navBack
            , div [] [ text "" ]
            , navItem model (routingButtonGenerator model.url.base_url)
            ]
        ]


infoPageHeaderNav : Model -> Html Msg
infoPageHeaderNav model =
    div [ class [ IntroNavWrapper ] ]
        [ div [ class [ HeaderNavContainer, InfoPageHeaderNav ] ]
            [ navItem model (routingButtonNavigation model.url.base_url)
            , div [] [ text "" ]
            , navItem model (routingButtonGenerator model.url.base_url)
            ]
        ]


folderListItems : List String -> List ServiceRecord -> List ( String, Int, Msg )
folderListItems folders savedServices =
    let
        all_count =
            savedServices |> List.length

        stared_count =
            savedServices
                |> filterByStarStatus
                |> List.length
    in
        [ ( "全部密码", all_count, DisplayModeSelected (FolderSelector AllFolders) )
        , ( "加星密码", stared_count, DisplayModeSelected Stared )
        ]
            ++ namedFolderItems folders savedServices


namedFolderItems : List String -> List ServiceRecord -> List ( String, Int, Msg )
namedFolderItems folders savedServices =
    folders
        |> List.map
            (\foldername ->
                let
                    count =
                        savedServices
                            |> filterByFolder (NamedFolder foldername)
                            |> List.length
                in
                    ( foldername, count, DisplayModeSelected (FolderSelector (NamedFolder foldername)) )
            )


folderTransferItems : List String -> List ServiceRecord -> List ( String, Int, Msg )
folderTransferItems folders savedServices =
    let
        all_count =
            savedServices |> List.length
    in
        ( "全部密码", all_count, FolderSelected AllFolders )
            :: namedFolderForTransfer folders savedServices


namedFolderForTransfer : List String -> List ServiceRecord -> List ( String, Int, Msg )
namedFolderForTransfer folders savedServices =
    folders
        |> List.map
            (\foldername ->
                let
                    count =
                        savedServices
                            |> filterByFolder (NamedFolder foldername)
                            |> List.length
                in
                    ( foldername, count, FolderSelected (NamedFolder foldername) )
            )


serviceListView : DisplayMode -> Maybe String -> Maybe ServiceItemOffset -> List ServiceRecord -> Html Msg
serviceListView displayMode serviceFilter serviceItemOffset savedServices =
    div [ class [ ServiceContainer ] ]
        (savedServices
            |> filterByDisplayMode displayMode
            |> filterByService serviceFilter
            |> List.map (serviceItemView serviceItemOffset)
        )


serviceItemView : Maybe ServiceItemOffset -> ServiceRecord -> Html Msg
serviceItemView serviceItemOffset service =
    let
        startStatusClass =
            case service.stared of
                True ->
                    "fa fa-star"

                False ->
                    "fa fa-star-o"

        itemOffset =
            case serviceItemOffset of
                Nothing ->
                    0

                Just { name, offset } ->
                    if name == service.service then
                        offset
                    else
                        0
    in
        div
            [ class [ ServiceItem ]
            , (onMouseDown service.service)
            , onClick (SelectService service)
            , styles
                [ marginLeft (px (toFloat itemOffset))
                ]
            ]
            [ div [ class [ ServiceItemMetaContainer ] ]
                [ div [ class [ MetaItem, ServiceCreatedTime ] ]
                    [ text (displayTime service.time)
                    ]
                , div
                    [ class [ MetaItem, CursorPoint ]
                    , onClick ToggleStarStatus
                    ]
                    [ i [ Html.Attributes.class startStatusClass ] []
                    ]
                ]
            , div [ class [ ServiceDescription ] ] [ text service.service ]
            ]


generatorView : Model -> Html Msg
generatorView model =
    let
        buttonGroupClass =
            case model.generator.password == "" of
                True ->
                    GroupButtonDisabled

                False ->
                    GroupButton
    in
        div [ class [ Layout ] ]
            [ generatorHeaderNav model
            , div [ class [ GeneratorContainer ] ]
                [ pwMetaView model
                , Html.map PasswordMsg (generatorForm model.generator)
                , div [ class [ Result ] ]
                    [ label [] [ text "Your Password: " ]
                    , input
                        [ class [ Input, FinalPass ]
                        , readonly True
                        , Html.Attributes.id "generatedpassword"
                        , value model.generator.password
                        ]
                        [ text model.generator.password ]
                    ]
                , div
                    [ Html.Attributes.class "pure-button-group"
                    , class [ buttonGroupClass ]
                    ]
                    [ button
                        [ Html.Attributes.class "pure-button pure-button-primary"
                        , onClick SaveService
                        ]
                        [ text "保存服务名" ]
                    , button
                        [ Html.Attributes.class "pure-button pure-button-primary"

                        -- clipboard.js will handle the copy to clipboard
                        , attribute "data-clipboard-target" "#generatedpassword"
                        , Html.Attributes.id "copybutton"
                        ]
                        [ text "复制密码" ]
                    ]
                ]
            , div [ class [ Disclaimer ] ]
                [ text "We won't save your password, we will only generate the password for you based on the key and service, you just need to keep the key as secret, we will store the service you used for later check" ]
            ]


folderTransferDropdownConfig : Dropdown.Config Msg
folderTransferDropdownConfig =
    { defaultText = "-- pick a country --"
    , withBorder = True
    , clickedMsg = Toggle FolderTransferOpen
    }


pwMetaView : Model -> Html Msg
pwMetaView model =
    let
        folderName =
            case model.selectedFolder of
                AllFolders ->
                    "全部密码"

                NamedFolder name ->
                    name

        context =
            { selectedItem = Just folderName
            , isOpen = model.openDropDown == FolderTransferOpen
            }

        startStatusClass =
            case model.stared of
                True ->
                    "fa fa-star"

                False ->
                    "fa fa-star-o"
    in
        div [ class [ MetaContainer ] ]
            [ Dropdown.view
                folderTransferDropdownConfig
                context
                (folderTransferItems model.folders model.savedServices)
            , div [ class [ MetaItem ] ] [ text (displayTime model.currentTime) ]
            , div
                [ class [ MetaItem ]
                , onClick ToggleStarStatus
                ]
                [ i [ Html.Attributes.class startStatusClass ] []
                ]
            ]


navigationView : Model -> Html Msg
navigationView model =
    div [ class [ Layout ] ]
        [ navigationHeaderNav model
        , navigation model (class [ NavigationContentContainer ]) (class [ NavigationMenuContainer ])
        ]


newPassword : Html Msg
newPassword =
    div [ class [ NewPwContainer ] ] []


renderInfoPage : Model -> Html Msg
renderInfoPage model =
    let
        postList =
            case model.route == ImplementationRoute of
                True ->
                    renderPosts model

                False ->
                    div [] []
    in
        div [ class [ IntroLayout ] ]
            [ infoPageHeaderNav model
            , hero model.currentContent.hero model.currentContent.title
            , h1 [ class [ PostHead ] ] [ text model.currentContent.title ]
            , renderPageMeta model.currentContent
            , renderMarkdown model.currentContent.markdown
            , postList
            , renderFooter
            ]


renderPageMeta : Content -> Html Msg
renderPageMeta content =
    div [ class [ ContentMeta ] ]
        [ p []
            [ text
                ("Published on " ++ ViewHelpers.formatDate content.publishedDate ++ " by " ++ content.author.name ++ ".")
            ]
        ]


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    article [ class [ MarkdownWrapper ] ]
        [ convertMarkdownToHtml markdown ]


convertMarkdownToHtml : WebData String -> Html Msg
convertMarkdownToHtml markdown =
    case markdown of
        Success data ->
            Markdown.toHtml [ class [ MarkdownContent ] ] data

        Failure err ->
            Debug.log (toString (err))
                text
                "There was an error"

        _ ->
            text "Loading"


renderPosts : Model -> Html Msg
renderPosts model =
    div [ class [ ContentContainer ] ]
        (posts
            |> filterByTitle model.titleFilter
            |> List.take 5
            |> List.map (renderPostPreview model.url.base_url)
        )


renderPostPreview : String -> Content -> Html Msg
renderPostPreview base_url content =
    let
        slug =
            content.slug

        onClickCmd =
            (NewUrl (base_url ++ slug))
    in
        div [ class [ PostPreview ] ]
            [ a
                [ href slug
                , navigationOnClick (onClickCmd)
                ]
                [ h2 [ class [ PostPreviewTitle ] ] [ text content.title ]
                , p [ class [ PostContentPreview ] ] [ text content.preview ]
                ]
            , p [ class [ PostPreviewMeta ] ]
                [ text
                    ("Published on " ++ formatDate content.publishedDate ++ " by " ++ content.author.name ++ ".")
                ]
            ]


hero : String -> String -> Html Msg
hero srcUrl textToShow =
    div
        [ class [ Hero ]
        , styles
            [ backgroundImage (url srcUrl)
            ]
        ]
        [ h1 [] [ text textToShow ]
        ]


renderFooter : Html Msg
renderFooter =
    footer [ class [ Footer ] ]
        [ ul [ class [ FooterNavContainer ] ]
            (footerRoutingItem
                |> List.map footerLinkItem
            )
        , p [ class [ CopyRight ] ]
            [ text "All code for this site is open source and written in Elm. "

            --, text "! — © 2017 Meilab"
            , iframe
                [ class [ GithubIframe ]
                , width 100
                , height 20
                , src "https://ghbtns.com/github-btn.html?user=meilab&repo=elm_blog&type=star&count=true"
                ]
                []
            ]
        ]


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Page Not Found" ]
