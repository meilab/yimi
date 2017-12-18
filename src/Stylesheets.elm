port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Styles.General exposing (..)


port files : CssFileStructure -> Cmd msg


fileStructures : CssFileStructure
fileStructures =
    Css.File.toFileStructure
        [ ( "/static/css/app.css"
          , Css.File.compile
                [ Styles.General.css ]
          )
        ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructures
