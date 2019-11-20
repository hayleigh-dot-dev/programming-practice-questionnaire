module Data.QSort exposing
  ( BasicSort, BasicCategory
  , createBasicSort, selectBasicItem, sortBasicItem
  , viewBasicSort
  --
  , QuasiNormalSort
  , fromBasicSort
  , viewNormalSort
  )

-- Imports ---------------------------------------------------------------------
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Ui.Section as Ui
import Set exposing (Set)

-- Types -----------------------------------------------------------------------
type alias BasicSort =
  { negative : List String
  , neutral : List String
  , positive : List String
  , unsorted : List String
  , selected : Maybe String
  , title : String
  , description : String
  }

type alias QuasiNormalSort =
  { basic : BasicSort
  , length : Int
  , items : List (Maybe String)
  }

type BasicCategory
  = Negative
  | Neutral
  | Positive

-- Constants -------------------------------------------------------------------


-- Functions -------------------------------------------------------------------
--
createBasicSort : String -> String -> Set String -> BasicSort
createBasicSort title description items =
  { negative = []
  , neutral = []
  , positive = []
  , unsorted = Set.toList items
  , selected = Nothing
  , title = title
  , description = description
  }

--
selectBasicItem : String -> BasicSort -> BasicSort
selectBasicItem item sort =
  if List.member item sort.unsorted then
    { sort
    | selected = Just item
    }
  else
    { sort
    | selected = Nothing
    }

--
sortBasicItem : BasicCategory -> BasicSort -> BasicSort
sortBasicItem category sort =
  let
    sortItem : String -> BasicSort
    sortItem item =
      case category of
        Negative ->
          { sort
          | unsorted = List.filter ((/=) item) sort.unsorted
          , negative = item :: sort.negative
          }

        Neutral ->
          { sort
          | unsorted = List.filter ((/=) item) sort.unsorted
          , neutral = item :: sort.neutral
          }

        Positive ->
          { sort
          | unsorted = List.filter ((/=) item) sort.unsorted
          , positive = item :: sort.positive
          }
  in
  Maybe.map sortItem sort.selected
    |> Maybe.withDefault sort

--
fromBasicSort : BasicSort -> QuasiNormalSort
fromBasicSort ({ negative, neutral, positive } as sort) =
  let
    nearestSquare : Int -> Int
    nearestSquare n =
      Basics.toFloat n
        |> Basics.sqrt
        |> Basics.round
        |> \x -> x ^ 2

    length : Int
    length =
      List.length negative + List.length neutral + List.length positive
        |> nearestSquare

  in
  { basic = sort
  , length = length
  , items = List.repeat length Nothing
  }

 -- View -----------------------------------------------------------------------
viewBasicSort : (String -> msg) -> (BasicCategory -> msg) -> BasicSort -> Html msg
viewBasicSort clickHandler categoryHandler sort =
  Ui.section sort.title sort.description
    [ A.attribute "data-q-sort" "basic" ]
    [ H.div [ A.class "px-2" ]
      -- Unsorted items
      [ H.div [ A.class "flex justify-between mb-4" ]
        [ H.button [ A.class "flex-grow bg-gray-300 mr-2 hover:bg-gray-500 p-2 rounded", E.onClick (categoryHandler Negative) ] 
          [ H.text "Negative"]
        , H.button [ A.class "flex-grow bg-gray-300 hover:bg-gray-500 p-2 rounded", E.onClick (categoryHandler Neutral) ] 
          [ H.text "Neutral"]
        , H.button [ A.class "flex-grow bg-gray-300 ml-2 hover:bg-gray-500 p-2 rounded", E.onClick (categoryHandler Positive) ] 
          [ H.text "Positive"]
        ]
      , H.ul [ A.class "bg-gray-400 rounded-lg h-64 overflow-y-scroll p-2" ]
        ( sort.unsorted |> List.map (\item -> H.text item |> List.singleton |> H.li 
          [ A.class "hover:bg-gray-600 p-2 rounded cursor-pointer"
          , A.class (if sort.selected == Just item then "bg-gray-500" else "")
          , E.onClick (clickHandler item) 
          ]
        ))
      ]
    , H.div [ A.class "px-2" ]
      -- Negative items
      [ H.div [ A.class "bg-gray-400 rounded-lg h-48 mb-4 p-2 overflow-y-scroll" ]
        [ H.h2 [ A.class "text-lg font-bold" ] [ H.text "Negative" ]
        , H.ul [ A.attribute "data-q-sort" "category" ]
          ( sort.negative |> List.map (H.text >> List.singleton >>
            H.li [])
          )
        ]
      -- Neutral items
      , H.div [ A.class "bg-gray-400 rounded-lg h-48 mb-4 p-2 overflow-y-scroll" ]
        [ H.h2 [ A.class "text-lg font-bold" ] [ H.text "Neutral" ]
        , H.ul [ A.attribute "data-q-sort" "category" ]
          ( sort.neutral |> List.map (H.text >> List.singleton >>
            H.li [])
          )
        ]
      -- Positive items
      , H.div [ A.class "bg-gray-400 rounded-lg h-48 p-2 overflow-y-scroll" ]
        [ H.h2 [ A.class "text-lg font-bold" ] [ H.text "Positive" ]
        , H.ul [ A.attribute "data-q-sort" "category" ]
          ( sort.positive |> List.map (H.text >> List.singleton >>
            H.li [])
          )
        ]
      ]
    ]

viewNormalSort : QuasiNormalSort -> Html msg
viewNormalSort sort =
  Ui.section sort.basic.title sort.basic.description
    [ A.attribute "data-q-sort" "normal" ]
    [
    ]