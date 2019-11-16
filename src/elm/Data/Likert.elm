module Data.Likert exposing
  ( Scale, scale
  , threePointScale, fivePointScale, sevenPointScale
  , rate
  , toHtml
  )

-- Imports ---------------------------------------------------------------------
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Set exposing (Set)

-- Types -----------------------------------------------------------------------
type alias Scale =
  { statements : List Statement
  , ratings : List Rating
  , title : String
  , description : String
  }

type alias Statement =
  ( Int, String )

type alias Rating =
  ( Int, String )

-- Functions -------------------------------------------------------------------
--
ratingsFromMedian : Int -> Int -> List Int
ratingsFromMedian count median =
  List.range (median - count // 2) (median + count // 2)

scale : String -> String -> Set String -> List String -> Scale
scale title description statements labels =
  let
    zip : List a -> List b -> List ( a, b )
    zip xs ys =
      List.map2 Tuple.pair xs ys

    ratingValues : List Int
    ratingValues =
      ratingsFromMedian (List.length labels) 0
  in
  { statements = (Set.toList >> List.map (Tuple.pair 0)) statements
  , ratings = zip ratingValues labels
  , title = title
  , description = description
  }

--
threePointScale : String -> String -> Set String -> Scale
threePointScale title description statements =
  scale title description statements
    [ "Disagree"
    , "Neutral"
    , "Agree"
    ]

--
fivePointScale : String -> String -> Set String -> Scale
fivePointScale title description statements =
  scale title description statements
    [ "Strongly Disagree"
    , "Disagree"
    , "Neutral"
    , "Agree"
    , "Strongly Agree"
    ]

--
sevenPointScale : String -> String -> Set String -> Scale
sevenPointScale title description statements =
  scale title description statements
    [ "Strongly Disagree"
    , "Disagree"
    , "Somewhat Disagree"
    , "Neutral"
    , "Somewhat Agree"
    , "Agree"
    , "Strongly Agree"
    ]

--
rate : String -> Int -> Scale -> Scale
rate statement value likertScale =
  let
    -- Taken from List.Extra; updates an item in a list if it satisfies some
    -- predicate function.
    updateIf : (a -> Bool) -> (a -> a) -> List a -> List a
    updateIf predicate f =
      List.map (\a -> if predicate a then f a else a)

    -- This ensures that if erroneous ratings come in that are out of range that
    -- we default to the middle rating (which should be neutral).
    rateWithDefault : Int -> List Int -> Int
    rateWithDefault rating range =
      if List.member rating range then
        rating
      else
        List.sum range // 2
    
    ratingValues : List Int
    ratingValues =
      likertScale.ratings |> List.map Tuple.first

    statements : List Statement
    statements =
      likertScale.statements |> updateIf
        (Tuple.second >> (==) statement)
        (Tuple.mapFirst (always (rateWithDefault value ratingValues)))
  in
  { likertScale | statements = statements }

-- View ------------------------------------------------------------------------
--
toHtml : (String -> Int -> msg) -> Scale -> Html msg
toHtml handler likert =
  let
    labels : Html msg
    labels =
      viewLabels likert.ratings

    statements : List (Html msg)
    statements =
      likert.statements |> List.map (viewStatement handler likert.ratings)
  in
  H.section [ A.class "bg-gray-200 rounded-lg py-4 px-10 m-4" ]
    [ H.h2 [ A.class "text-bold text-2xl border-b-2 border-black mb-2" ]
      [ H.text likert.title ]
    , H.p [ A.class "mb-4 text-justify" ] [ H.text likert.description ]
    , H.ul [ A.class <| "likert-scale-" ++ (String.fromInt << List.length) likert.ratings ]
      ( labels :: statements )
    ]

--
viewStatement : (String -> Int -> msg) -> List Rating -> Statement -> Html msg
viewStatement handler ratings ( currentRating, statement ) =
  let
    -- 
    radios : List (Html msg)
    radios =
      ratings |> List.map (Tuple.first >> \r ->
        H.span [ A.class "flex justify-center" ]
          [ H.input 
            [ A.type_ "radio", A.checked (r == currentRating)
            , A.class "flex justify-center"
            , E.onClick (handler statement r)
            ]  []
          ]
      )
  in
  H.li [ A.class "m-2" ]
    ( H.span [ A.class "mr-8" ] [ H.text statement ] :: radios )

--
viewLabels : List Rating -> Html msg
viewLabels ratings =
  H.li [ A.class "mb-4" ]
    ( H.br [] [] :: (ratings |> List.map (\( _, label ) ->
      H.span [ A.class "inline-block text-center" ]
        [ H.text label ]
    )))