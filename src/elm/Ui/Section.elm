module Ui.Section exposing
  ( section
  )

-- Imports ---------------------------------------------------------------------
import Html as H exposing (Html, Attribute)
import Html.Attributes as A
import Html.Events as E

-- Types -----------------------------------------------------------------------


-- Constants -------------------------------------------------------------------


-- Functions -------------------------------------------------------------------


-- View -----------------------------------------------------------------------
section : String -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
section title description attrs children =
  H.section (A.class "bg-gray-200 m-4 px-10 py-4 rounded-lg" :: attrs)
    [ H.h2 [ A.class "border-b-2 border-black mb-2 text-2xl text-bold" ]
      [ H.text title ]
    , H.p [ A.class "mb-4 text-justify" ]
      [ H.text description ]
    , H.div [ A.class "container" ] children
    ]