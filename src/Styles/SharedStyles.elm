module Styles.SharedStyles exposing (..)

import Html.CssHelpers exposing (withNamespace)


type CssClass
    = Layout
    | IntroLayout
    | Container
    | NewPwContainer
    | ContentContainer
    | FolderListWrapper
    | FolderListActive
    | FolderListInActive
    | FolderListContainer
    | FolderItem
    | FolderDescription
    | FolderTransferWrapper
    | FolderTransferActive
    | FolderTransferInActive
    | FolderTransferContainer
    | Searcher
    | SearchBar
    | SearchIcon
    | SearchClear
    | IconImg
      -- serviceView
    | ServiceContainer
    | ServiceItem
    | ServiceDescription
    | ServiceCreatedTime
      -- NavigationPage
    | NavigationContentContainer
    | NavigationMenuContainer
      -- Sidemenu
    | SideBarWrapper
    | SideBarMenu
    | SideBarActive
    | SideBarInactive
    | MenuContainer
    | MenuContainerVertical
    | MenuItem
    | MenuLink
    | MenuSelected
    | MenuActive
    | MenuInActive
    | MenuToggler
      -- Header and Footer
    | Header
    | HeaderNavWrapper
    | HeaderNavContainer
    | InfoPageHeaderNav
    | IntroNavWrapper
    | HeaderNav
    | Footer
    | FooterNavContainer
    | CopyRight
    | GithubIframe
      -- Generator
    | GeneratorContainer
    | MetaContainer
    | ServiceItemMetaContainer
    | MetaItem
    | GeneratorFormContainer
    | GeneratorFormItem
    | CategorySelectorContainer
    | CategorySelector
    | Disclaimer
    | Arrow
    | DropdownContainer
    | DropdownInput
    | DropdownInputWithBorder
    | DropdownDisabled
    | DropdownText
    | DropdownList
    | DropdownListItem
    | GroupButton
    | GroupButtonDisabled
    | Hero
    | MarkdownWrapper
    | MarkdownContent
    | CursorPoint
    | Input
    | Result
    | FinalPass
    | ContentMeta
    | MorePostsLink
    | PostHead
    | PostPreview
    | PostPreviewMeta
    | PostPreviewTitle
    | PostPreviewSubtitle
    | PostContentPreview


meilabNamespace : Html.CssHelpers.Namespace String class id msg
meilabNamespace =
    withNamespace ""
