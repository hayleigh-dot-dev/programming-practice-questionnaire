module Pages.Demographics exposing
  ( view
  )

{- Imports ------------------------------------------------------------------ -}
import Html exposing (Html)
import Html.Attributes
import Html.Events

import Data.MultipleChoice exposing (MultipleChoice)

import Ui.Section

{- Types -------------------------------------------------------------------- -}
type alias Data model =
  { model
  | multipleChoiceQuestions : List MultipleChoice
  }

type alias Events msg =
  { optionSelected : Int -> Data.MultipleChoice.Option -> msg
  , optionAdded : Int -> String -> msg
  }

{- View --------------------------------------------------------------------- -}
view : Data model -> Events msg -> List (Html msg)
view model { optionSelected, optionAdded }=
  [ Html.main_
    [ Html.Attributes.class "container md:mx-auto px-4" ]
    ( model.multipleChoiceQuestions |> List.indexedMap (\i mc ->
        Data.MultipleChoice.toHtml mc
          { optionSelected = optionSelected i
          , optionAdded = optionAdded i
          }
    ))
  , Html.footer
    [ Html.Attributes.class "flex mt-4 py-2 container md:mx-auto px-4" ]
    [ Html.a
      [ Html.Attributes.class 
          <| "flex-1 mr-10 bg-transparent hover:bg-blue-500 text-blue-700 "
          ++ "font-semibold hover:text-white py-2 px-4 border border-blue-500 "
          ++ "hover:border-transparent rounded"
      , Html.Attributes.href "/consent" 
      ]
      [ Html.text "back" ]
    , Html.a
      [ Html.Attributes.class 
          <| "flex-1 ml-10 bg-blue-500 hover:bg-blue-700 text-white font-bold "
          ++ "py-2 px-4 rounded"
      , Html.Attributes.href "/2" 
      ]
      [ Html.text "next" ]
    ]
  ]
