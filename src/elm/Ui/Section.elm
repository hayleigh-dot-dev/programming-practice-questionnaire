module Ui.Section exposing
  ( standard
  , full
  )

-- Imports ---------------------------------------------------------------------
import Html as H exposing (Html, Attribute)
import Html.Attributes as A

-- Section ---------------------------------------------------------------------
standard : String -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
standard title description attrs children =
  H.section (A.class "container mx-auto bg-gray-200 my-4 px-10 py-4 rounded-lg" :: attrs)
    [ H.h2 [ A.class "border-b-2 border-black mb-2 text-2xl text-bold" ]
      [ H.text title ]
    , H.p [ A.class "mb-4 text-justify" ]
      [ H.text description ]
    , H.div [ A.class "container" ] children
    ]

full : String -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
full title description attrs children =
  H.section (A.class "w-screen bg-gray-200 my-4 px-10 py-4 rounded-lg" :: attrs)
    [ H.h2 [ A.class "border-b-2 border-black mb-2 text-2xl text-bold" ]
      [ H.text title ]
    , H.p [ A.class "mb-4 text-justify" ]
      [ H.text description ]
    , H.div [ A.class "" ] children
    ]
  

