module Update exposing (..)

import Models exposing (..)
import Messages exposing (Msg(..))
import Navigation exposing (Location)
import Routing exposing (Route(..), parseLocation)
import Types
    exposing
        ( Content
        , OpenDropdown(..)
        , ModelToJs
        , PasswordCategory(..)
        , FolderType(..)
        , Drag
        , ServiceItemOffset
        )
import Password.Utils exposing (jsConfig2ElmConfig, elmConfig2JsConfig)
import Password.Update
import Task exposing (Task)
import Time exposing (Time)
import Storage exposing (..)
import ContentUtils exposing (allContent, filterByRoute)
import FetchContent
import Pages


changeUrlCommand : String -> Route -> Content -> Cmd Msg
changeUrlCommand base_url route content =
    case
        (route == HomeRoute)
            || (route == GeneratorRoute)
            || (route == NavigationRoute)
    of
        True ->
            Cmd.none

        False ->
            FetchContent.fetch content base_url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location model.url.base_url

                newContent =
                    filterByRoute newRoute allContent
                        |> Maybe.withDefault Pages.notFound404

                newModel =
                    { model
                        | route = newRoute
                        , currentContent = newContent
                    }
            in
                ( newModel
                , changeUrlCommand model.url.base_url newRoute newContent
                )

        NewUrl url ->
            model ! [ Navigation.newUrl url ]

        Backward ->
            model ! [ Navigation.back 1 ]

        FetchedContent response ->
            let
                currentContent =
                    model.currentContent

                newContent =
                    { currentContent | markdown = response }
            in
                ( { model | currentContent = newContent }
                , Cmd.none
                )

        ToggleFolderList ->
            ( { model | ui = Ui (not model.ui.folderListActive) }, Cmd.none )

        Toggle dropdown ->
            let
                newOpenDropDown =
                    if model.openDropDown == dropdown then
                        AllClosed
                    else
                        dropdown
            in
                { model
                    | openDropDown = newOpenDropDown
                }
                    ! []

        PasswordMsg subMsg ->
            let
                ( updatedGenerator, cmd ) =
                    Password.Update.update subMsg model.generator
            in
                ( { model | generator = updatedGenerator }, Cmd.map PasswordMsg cmd )

        SaveService ->
            ( model, Task.perform OnTime Time.now )

        SaveServiceSucc services ->
            let
                generator =
                    model.generator

                newGenerator =
                    { generator | service = "", password = "" }
            in
                ( { model
                    | savedServices = services
                    , generator = newGenerator
                    , stared = False
                  }
                , Cmd.none
                )

        SaveServiceFail err ->
            Debug.log (toString (err))
                ( model, Cmd.none )

        OnTime time ->
            let
                folderType =
                    case model.selectedFolder of
                        AllFolders ->
                            "全部密码"

                        NamedFolder name ->
                            name

                -- update if service exist
                services =
                    model.savedServices
                        |> List.filter (\x -> x.service /= model.generator.service)

                newSavedServices =
                    { service = model.generator.service
                    , time = time
                    , config = elmConfig2JsConfig model.generator.config
                    , stared = model.stared
                    , folderType = folderType
                    }
                        :: services
            in
                ( model, (saveServices newSavedServices) )

        -- If dragOffset > threshold,
        -- we think it is drag and need to cancel clickhandler: do nothing
        SelectService selectedService ->
            let
                offset =
                    case model.drag of
                        Nothing ->
                            0

                        Just { start, current } ->
                            current.x - start.x

                ( newModel, newCmd ) =
                    case (offset > dragOffsetThresh || offset < -dragOffsetThresh) of
                        True ->
                            ( model, Cmd.none )

                        False ->
                            let
                                generator =
                                    model.generator

                                newConfig =
                                    jsConfig2ElmConfig selectedService.config

                                newGenerator =
                                    { generator
                                        | service = selectedService.service
                                        , primaryKey = ""
                                        , password = ""
                                        , config = newConfig
                                    }

                                newFolderType =
                                    case selectedService.folderType of
                                        "all" ->
                                            AllFolders

                                        folderName ->
                                            NamedFolder folderName

                                newModel =
                                    { model
                                        | generator = newGenerator
                                        , stared = selectedService.stared
                                        , selectedFolder = newFolderType
                                    }

                                newCmd =
                                    Navigation.newUrl (model.url.base_url ++ "/generator")
                            in
                                ( newModel, newCmd )
            in
                ( newModel
                , newCmd
                )

        ClearService ->
            ( model, Cmd.none )

        SaveDefaultConfig defaultConfig ->
            let
                defaultConfigToJs =
                    elmConfig2JsConfig defaultConfig
            in
                ( { model | defaultConfig = defaultConfig }, Cmd.none )

        DeleteService serviceName ->
            let
                newSavedServices =
                    model.savedServices
                        |> List.filter (\service -> service.service /= serviceName)
            in
                ( { model | savedServices = newSavedServices }
                , Cmd.none
                )

        UpdateServiceFilter keyword ->
            ( { model | serviceFilter = Just keyword }, Cmd.none )

        DisplayModeSelected mode ->
            ( { model
                | displayMode = mode
                , openDropDown = AllClosed
              }
            , Cmd.none
            )

        FolderSelected folder ->
            ( { model
                | selectedFolder = folder
                , openDropDown = AllClosed
              }
            , Cmd.none
            )

        Blur ->
            ( { model
                | openDropDown = AllClosed
                , serviceItemOffset = Nothing
              }
            , Cmd.none
            )

        ToggleStarStatus ->
            ( { model | stared = not model.stared }, Cmd.none )

        GetServices ->
            ( model, getServices "service" )

        ReceiveServices services ->
            let
                newCmd =
                    case services of
                        [] ->
                            Navigation.newUrl (model.url.base_url ++ "/generator")

                        _ ->
                            Cmd.none
            in
                ( { model | savedServices = services }, newCmd )

        Tick time ->
            ( { model | currentTime = time }, Cmd.none )

        -- serviceItemOffset will be cleared at DragEnd
        -- or Blur, so we need to disable Blur during Drag
        DragStart serviceName xy ->
            let
                newItemOffset =
                    Just (ServiceItemOffset serviceName 0)
            in
                ( { model
                    | drag = Just (Drag xy xy)
                    , serviceItemOffset = newItemOffset
                  }
                , Cmd.none
                )

        DragAt xy ->
            let
                offset =
                    getDragOffset model.drag
            in
                ( { model
                    | drag =
                        Maybe.map
                            (\{ start } -> Drag start xy)
                            model.drag
                    , serviceItemOffset =
                        Maybe.map
                            (\{ name } -> ServiceItemOffset name offset)
                            model.serviceItemOffset
                  }
                , Cmd.none
                )

        DragEnd xy ->
            let
                offset =
                    getDragOffset model.drag

                newSavedServices =
                    case model.serviceItemOffset of
                        Just { name } ->
                            if offset < -dragOffsetThresh then
                                model.savedServices
                                    |> List.filter (\service -> service.service /= name)
                            else
                                model.savedServices

                        Nothing ->
                            model.savedServices
            in
                ( { model
                    | drag = Nothing
                    , serviceItemOffset = Nothing
                    , savedServices = newSavedServices
                  }
                , Cmd.none
                )

        NoOp ->
            ( model, Cmd.none )


getDragOffset : Maybe Drag -> Int
getDragOffset drag =
    case drag of
        Nothing ->
            0

        Just { start, current } ->
            current.x
                - start.x
                |> min dragOffsetThresh
