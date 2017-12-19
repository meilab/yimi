module Styles.General exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Colors exposing (..)
import Css.Media as Media exposing (media, only, screen, minWidth)
import Css.Namespace exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Styles.SharedStyles exposing (..)
import Styles.Colors exposing (..)
import Styles.SharedVariables exposing (..)


css : Stylesheet
css =
    (stylesheet << namespace meilabNamespace.name)
        [ html
            [ boxSizing borderBox ]
        , body
            [ fontSize (px 16)
            , fontFamily sansSerif
            , padding zero
            , margin zero
            , backgroundColor (hex "#fbf7ed")
            , color (hex "#434343")
            ]
        , p
            [ lineHeight (Css.em 1.6) ]
        , each [ h1, h2 ]
            [ padding zero
            , margin zero
            ]
        , h3
            [ margin2 (px 15) zero
            ]
        , img
            [ maxWidth (pct 100)
            , height auto
            ]
        , nav
            [ descendants
                [ ul
                    [ listStyleType none
                    , margin zero
                    , padding zero
                    , displayFlex
                    , justifyContent spaceBetween
                    , alignItems center
                    , textAlign center
                    ]
                ]
            ]
        , class Container
            [ displayFlex
            , flexDirection column
            , justifyContent flexStart
            , alignItems flexStart
            , textAlign center
            ]
        , class HeaderNavWrapper
            [ display none ]
        , each [ class Layout, class IntroLayout ]
            [ displayFlex
            , flexDirection column
            , alignItems center
            ]
        , class Layout
            [ marginTop navBarHeight ]
        , class ContentContainer
            [ flex (int 1)
            , width (pct 100)
            , minHeight (vh 100)
            , displayFlex
            , flexDirection column
            , alignItems center
            , maxWidth (px 759)
            , padding (Css.em 1)
            ]
        , class MarkdownWrapper
            [ displayFlex
            , flexDirection column
            , alignItems center
            , width (pct 100)
            ]
        , class MarkdownContent
            [ width (pct 90)
            , maxWidth (px 759)
            ]
        , class NavigationContentContainer
            [ width (vw 90)
            , minHeight (calc (vh 90) minus navBarHeight)
            , displayFlex
            , flexDirection column
            , justifyContent spaceAround
            ]
        , class NavigationMenuContainer
            [ width (pct 100)
            , flex (pct 70)
            , displayFlex
            , flexDirection column
            , justifyContent spaceAround
            , alignItems center
            , listStyle none
            , padding zero
            , margin zero
            , descendants
                [ a
                    [ textDecoration none
                    , textAlign center
                    , display block
                    , padding (px 10)
                    , color black
                    ]
                ]
            ]
        , class GeneratorContainer
            [ width (pct 100)
            , displayFlex
            , flexDirection column
            , alignItems center
            , maxWidth (px 759)
            ]
        , each [ class MetaContainer, class ServiceItemMetaContainer ]
            [ width (pct 100)
            , height (px 40)
            , displayFlex
            , justifyContent spaceBetween
            , alignItems center
            , borderBottom3 (px 1) solid contentBordercolor
            ]
        , class ServiceItemMetaContainer
            [ height (px 25) ]
        , class MetaItem
            [ displayFlex
            , flexDirection column
            , justifyContent center
            , alignItems center
            , textAlign center
            , margin2 zero (px 16)
            ]
        , class CursorPoint
            [ cursor pointer ]
        , class GeneratorFormContainer
            [ width (pct 90)
            , height (pct 100)
            , displayFlex
            , flexDirection column
            , marginTop (px 20)
            , marginBottom (px 20)
            , borderBottom3 (px 1) solid contentBordercolor
            ]
        , class GeneratorFormItem
            [ displayFlex
            , flexDirection column
            , marginBottom (px 20)
            ]
        , class CategorySelectorContainer
            [ width (pct 100)
            , displayFlex
            , justifyContent spaceAround
            , alignItems center
            ]
        , class CategorySelector
            []
        , each [ class MenuContainer, class MenuContainerVertical ]
            [ displayFlex
            , justifyContent spaceBetween
            , alignItems center
            ]
        , class MenuContainerVertical
            [ flexDirection column ]
        , class SideBarWrapper
            [ flex3 (int 0) (int 0) menuWidth
            , withClass MenuInActive
                [ display none ]
            ]
        , class SideBarMenu
            [ position fixed
            , width menuWidth
            , height (vh 100)
            , displayFlex
            , flexDirection column
            , justifyContent flexStart
            , backgroundColor ember
            ]
        , each [ class HeaderNavContainer, class FooterNavContainer ]
            [ width (pct 100)
            , displayFlex
            , justifyContent spaceAround
            , listStyle none
            , padding zero
            , margin zero
            , descendants
                [ a
                    [ textDecoration none
                    , textAlign center
                    , display block
                    , padding (px 10)
                    , color black
                    ]
                ]
            ]
        , class InfoPageHeaderNav
            [ descendants
                [ a [ color white ] ]
            ]
        , class MenuItem
            [ paddingLeft (Css.rem 0.2)

            --, border3 (px 1) solid bordercolor
            , borderRadius (px 8)
            , Css.minWidth (px 60)
            , minHeight (px 40)
            , cursor pointer
            , descendants
                [ a
                    [ hover
                        [ backgroundColor (hex "#8A7667") ]
                    ]
                ]
            ]
        , class MenuToggler
            [ position fixed
            , color white
            , padding (px 5)
            , left toggleMenuLeftCollapsed
            , top (px 20)
            , border3 (px 1) solid silver
            , descendants
                [ li
                    [ listStyleType none ]
                ]
            , withClass MenuActive
                [ left toggleMenuLeft ]
            , hover
                [ backgroundColor white
                , color black
                ]
            ]
        , class HeaderNav
            [ displayFlex
            , justifyContent center
            , color white
            , textTransform uppercase
            , descendants
                [ a
                    [ color white
                    , hover
                        [ color yellow
                        ]
                    , active
                        [ color yellow ]
                    ]
                ]
            ]
        , class SearchBar
            [ width (pct 90)
            , height (px 30)
            , displayFlex
            , justifyContent spaceAround
            , alignItems center
            , contentBorder
            , backgroundColor (hex "#fbf7ed")
            , borderRadius (px 14)
            , marginBottom (Css.em 1)
            ]
        , class SearchIcon
            [ flex3 (int 0) (int 0) (px 20)
            , height (px 20)
            , marginLeft (px 10)
            ]
        , class SearchClear
            [ flex3 (int 0) (int 0) (px 20)
            , height (px 20)
            , marginRight (px 10)
            ]
        , class Searcher
            [ flex (int 1)
            , height (px 28)

            --, lineHeight (px 24)
            , fontSize (px 14)
            , textAlign center
            , backgroundColor (hex "#fbf7ed")
            , outline zero
            , border zero
            ]
        , class IconImg
            [ width (Css.rem 3)
            , height auto
            ]
        , class ServiceContainer
            [ displayFlex
            , width (pct 90)
            , flexDirection column
            , alignItems center
            ]
        , class ServiceItem
            [ displayFlex
            , width (pct 100)
            , flexDirection column
            , backgroundColor (hex "#fbf7ed")
            , borderBottom3 (px 1) solid contentBordercolor
            , marginBottom (Css.em 1)
            , boxShadow5 inset (px 0) (px 1) (px 4) (rgba 0 0 0 0.03)
            , hover
                [ backgroundColor (hex "#f1ece1")
                , boxShadow4 (px 0) (px 1) (px 4) (rgba 0 0 0 0.03)
                ]
            ]
        , class ServiceDescription
            [ width (pct 100)
            , height (px 30)
            , lineHeight (px 20)
            , displayFlex
            , justifyContent center
            , alignItems center
            ]
        , class ServiceCreatedTime
            [ flex3 (int 0) (int 0) (px 120) ]
        , class FolderListWrapper
            [ position fixed
            , top navBarHeight
            , width (pct 100)
            , zIndex (int 10)
            , backgroundColor white
            , withClass FolderListInActive
                [ display none ]
            ]
        , class FolderTransferWrapper
            [ position fixed
            , top (px 128)
            , width (pct 100)
            , zIndex (int 10)
            , backgroundColor white
            , withClass FolderTransferInActive
                [ display none ]
            ]
        , class Disclaimer
            [ marginTop (px 64)
            , width (pct 90)
            , maxWidth (px 759)
            ]
        , class DropdownContainer
            [ position relative
            , margin (px 16)
            , Css.minWidth (px 120)
            , display inlineBlock
            , fontFamily sansSerif
            , fontSize (px 16)
            ]
        , each [ class DropdownInput, class DropdownInputWithBorder ]
            [ padding4 zero (px 12) zero (px 15)
            , height (px 22)
            , margin zero
            , borderRadius (px 4)
            , displayFlex
            , alignItems center
            , cursor pointer
            ]
        , class DropdownInputWithBorder
            [ border3 (px 1) solid (hex "#e4dad1")
            ]
        , class DropdownDisabled
            [ color (rgba 0 0 0 0.54) ]
        , class DropdownText
            [ flex auto
            , displayFlex
            , justifyContent center
            , alignItems center
            ]
        , class DropdownList
            [ position absolute
            , top (px 32)
            , borderRadius (px 4)
            , boxShadow4 (px 0) (px 1) (px 2) (rgba 0 0 0 0.24)
            , padding2 (px 4) (px 8)
            , margin zero
            , width (px 200)
            , backgroundColor (hex "#fbf7ed")
            ]
        , class DropdownListItem
            [ displayFlex
            , justifyContent spaceBetween
            , alignItems center
            , padding2 (px 8) (px 8)
            , color (hex "#7a706b")
            , borderBottom3 (px 1) solid (hex "#f2f2f1")
            , cursor pointer
            , hover
                [ backgroundColor (hex "#f5f2f1")
                , boxShadow4 (px 0) (px 1) (px 4) (rgba 0 0 0 0.03)
                ]
            ]
        , class Arrow
            [ position absolute
            , top (px -16)
            , left (px 22)
            , height (px 1)
            , width (px 1)
            , borderLeft3 (px 7) solid Css.transparent
            , borderRight3 (px 7) solid Css.transparent
            , borderBottom3 (px 7) solid (hex "#e2dcd6")
            , borderTop3 (px 7) solid Css.transparent
            ]
        , class GroupButton
            [ width (pct 80)
            , displayFlex
            , justifyContent spaceAround
            , alignItems center
            , margin2 (Css.em 1) zero
            ]
        , class GroupButtonDisabled
            [ display none ]
        , class Hero
            [ color white
            , width (pct 100)
            , height (vh 40)
            , backgroundColor (hex "#222")
            , backgroundAttachment fixed
            , backgroundRepeat noRepeat
            , backgroundSize cover
            , displayFlex
            , flexDirection column
            , justifyContent center
            , alignItems center
            , textAlign center
            ]
        , class Footer
            [ backgroundColor (hex "#fbf7ed")
            , color gray
            , padding2 (Css.em 3) (pct 10)
            , textAlign center
            , flex3 (int 0) (int 0) (px 120)
            , displayFlex
            , flexDirection column
            , justifyContent spaceAround
            , alignItems center
            ]
        , class CopyRight
            [ flex (int 1)
            , displayFlex
            , flexDirection column
            , justifyContent center
            , alignItems center
            , textAlign center
            ]
        , class GithubIframe
            [ border zero ]
        , class Input
            [ height (px 28)
            , fontSize (px 14)
            , backgroundColor white
            , outline zero
            ]
        , class Result
            [ displayFlex
            , width (pct 90)
            , fontSize (px 24)
            ]
        , class FinalPass
            [ flex3 (int 1) (int 1) (pct 65)
            , fontSize (px 24)
            ]
        , class PostPreview
            [ displayFlex
            , width (pct 90)
            , borderBottom3 (px 1) solid silver
            , flexDirection column
            , alignItems flexStart
            , children
                [ a
                    [ color (hex "#404040")
                    , textDecoration none
                    , hover
                        [ textDecoration none
                        , color (hex "0085a1")
                        ]
                    , focus
                        [ textDecoration none
                        , color (hex "0085a1")
                        ]
                    ]
                ]
            ]
        , class PostPreviewTitle
            [ fontSize (px 21)
            , lineHeight (Css.em 1.3)
            , marginTop (px 30)
            , marginBottom (px 8)
            ]
        , class PostPreviewSubtitle
            [ fontSize (px 15)
            , lineHeight (Css.em 1.3)
            , fontWeight (int 300)
            , marginBottom (px 10)
            ]
        , class PostPreviewMeta
            [ fontFamily sansSerif
            , color (hex "#808080")
            , fontSize (px 16)
            , fontStyle italic
            , marginTop zero
            ]
        , class MorePostsLink
            [ margin2 (Css.em 3) zero
            , displayFlex
            , flexDirection column
            , alignItems flexEnd
            , textAlign right
            , descendants
                [ a
                    [ color (hex "#404040")
                    , textDecoration underline
                    , border3 (px 1) solid silver
                    , hover
                        [ textDecoration none
                        , color (hex "0085a1")
                        ]
                    , focus
                        [ textDecoration none
                        , color (hex "0085a1")
                        ]
                    ]
                ]
            ]
        , class PostContentPreview
            [ fontSize (px 13)
            , fontStyle italic
            , color (hex "#a3a3a3")
            , hover [ color (hex "#0085a1") ]
            ]
        , class PostHead
            []
        , media [ only screen [ Media.minWidth (px 300) ] ]
            [ each [ class HeaderNavWrapper, class IntroNavWrapper ]
                [ top zero
                , height navBarHeight
                , width (pct 100)
                , displayFlex
                , flexDirection column
                , alignItems center
                ]
            , class IntroNavWrapper
                [ position absolute ]
            , class [ HeaderNavWrapper ]
                [ position fixed
                , border3 (px 1) solid bordercolor
                , backgroundImage (linearGradient (stop <| hex "#827265") (stop <| hex "#716053") [])
                , boxShadow4 (px 0) (px 1) (px 8) (rgba 0 0 0 0.15)
                ]
            , class HeaderNavContainer
                [ displayFlex
                , width (pct 90)
                , height (pct 100)
                , justifyContent spaceBetween
                , alignItems center
                ]
            ]
        ]
