module Pages.Likert exposing
  ( view
  )

{- Imports ------------------------------------------------------------------ -}
import Html exposing (Html)
import Html.Attributes
import Html.Events

import Data.Likert exposing (LikertScale)

{- Types -------------------------------------------------------------------- -}
type alias Data model =
  { model
  | likertScales : List LikertScale
  }

type alias Events msg =
  { itemChecked : Int -> String -> Data.Likert.Rating -> msg
  , submit : msg
  }

{- View --------------------------------------------------------------------- -}
view : Data model -> Events msg -> List (Html msg)
view model { itemChecked, submit } =
  [ Html.main_
    [ Html.Attributes.class "container md:mx-auto px-4" ]
    (Html.div
      [ Html.Attributes.class "container md:mx-auto px-16 mt-8 text-xl" ]
      [ Html.p
        [ Html.Attributes.class "mb-2" ]
        [ Html.text
            <| "This section is all about your programming practice. There are a "
            ++ "series of statements arranged into topics that you'll need to rate "
            ++ "your level of agreement with."
        ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "When considering each statement, think about how you approach a "
              ++ "typical audio programming project and answer accordingly. It's "
              ++ "important to stress that there are no right or 'best' responses "
              ++ "to each of these statements."
          ]
        ] 
      :: ( model.likertScales |> List.indexedMap (\i scale ->
        Data.Likert.toHtml (itemChecked i) scale
    )))
  , Html.footer
    [ Html.Attributes.class "flex mt-4 py-2 container md:mx-auto px-4" ]
    [ Html.a
      [ Html.Attributes.class 
          <| "flex-1 mr-10 bg-transparent hover:bg-blue-500 text-blue-700 "
          ++ "font-semibold hover:text-white py-2 px-4 border border-blue-500 "
          ++ "hover:border-transparent rounded"
      , Html.Attributes.href "/1" 
      ]
      [ Html.text "back" ]
    , Html.a
      [ Html.Attributes.class 
          <| "flex-1 ml-10 bg-blue-500 hover:bg-blue-700 text-white font-bold "
          ++ "py-2 px-4 rounded"
      , Html.Attributes.href "/3" 
      , Html.Events.onClick submit
      ]
      [ Html.text "next" ]
    ]
  ]
