module Data.Likert exposing
  ( LikertScale, init
  , Rating
  , threePointScale, fivePointScale, sevenPointScale
  , rate
  , toHtml
  , encode, decoder
  )

-- Imports ---------------------------------------------------------------------
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder)
import Ui.Section
import Set exposing (Set)
import Data.Tuple as Tuple exposing (Tuple)

-- Types -----------------------------------------------------------------------
type alias LikertScale =
  { title : String
  , description : String
  , statements : List Statement
  , ratings : List Rating
  }

type Rating
  = StronglyDisagree
  | Disagree
  | SomewhatDisagree
  | Neutral
  | SomewhatAgree
  | Agree
  | StronglyAgree

-- 
type alias Statement =
  Tuple Rating String

-- Functions -------------------------------------------------------------------
init : String -> String -> Set String -> List Rating -> LikertScale
init title description statements ratings =
  { title = title
  , description = description
  , statements = (Set.toList >> List.map (Tuple.pair Neutral)) statements
  , ratings = ratings
  }

--
threePointScale : String -> String -> Set String -> LikertScale
threePointScale title description statements =
  init title description statements
    [ Disagree
    , Neutral
    , Agree
    ]

--
fivePointScale : String -> String -> Set String -> LikertScale
fivePointScale title description statements =
  init title description statements
    [ StronglyDisagree
    , Disagree
    , Neutral
    , Agree
    , StronglyAgree
    ]

--
sevenPointScale : String -> String -> Set String -> LikertScale
sevenPointScale title description statements =
  init title description statements
    [ StronglyDisagree
    , Disagree
    , SomewhatDisagree
    , Neutral
    , SomewhatAgree
    , Agree
    , StronglyAgree
    ]

--
rate : String -> Rating -> LikertScale -> LikertScale
rate statement rating scale =
  let
    -- Taken from List.Extra; updates an item in a list if it satisfies some
    -- predicate function.
    updateIf : (a -> Bool) -> (a -> a) -> List a -> List a
    updateIf predicate f =
      List.map (\a -> if predicate a then f a else a)

    statements : List Statement
    statements =
      scale.statements |> updateIf
        (Tuple.second >> (==) statement)
        (Tuple.mapFirst (always rating))
  in
  { scale | statements = statements }

-- View ------------------------------------------------------------------------
--
ratingToString : Rating -> String
ratingToString rating =
  case rating of
    StronglyDisagree  -> "Strongly Disagree"
    Disagree          -> "Disagree"
    SomewhatDisagree  -> "Somewhat Disagree"
    Neutral           -> "Neutral"
    SomewhatAgree     -> "Somewhat Agree"
    Agree             -> "Agree"
    StronglyAgree     -> "Strongly Agree"

--
toHtml : (String -> Rating -> msg) -> LikertScale -> Html msg
toHtml handler scale =
  let
    labels : Html msg
    labels =
      viewLabels scale.ratings

    statements : List (Html msg)
    statements =  
      scale.statements |> List.map (viewStatement handler scale.ratings)
  in
  Ui.Section.standard scale.title scale.description
    [ A.attribute "data-likert" <| (String.fromInt << List.length) scale.ratings ]
    [ H.ul []
      ( labels :: statements )
    ]

--
viewStatement : (String -> Rating -> msg) -> List Rating -> Statement -> Html msg
viewStatement handler ratings ( currentRating, statement ) =
  let
    -- 
    radios : List (Html msg)
    radios =
      ratings |> List.map (\r ->
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
    ( H.br [] [] :: (ratings |> List.map (\r ->
      H.span [ A.class "text-center" ]
        [ H.text <| ratingToString r ]
    )))

-- JSON ------------------------------------------------------------------------
encode : LikertScale -> Encode.Value
encode { title, description, statements, ratings } =
  let
    encodeStatement : Statement -> Encode.Value
    encodeStatement (rating, statement) =
      Encode.object
        [ ("rating", Encode.string (ratingToString rating))
        , ("statement", Encode.string statement)
        ]
  in
  Encode.object
    [ ("title", Encode.string title)
    , ("description", Encode.string description)
    , ("statements", Encode.list encodeStatement statements)
    , ("ratings", Encode.list Encode.string <| List.map ratingToString ratings)
    ]

decoder : Decoder LikertScale
decoder =
  let
    statementDecoder : Decoder Statement
    statementDecoder =
      Decode.oneOf
        [ Decode.map2 Tuple.pair
            (Decode.field "rating" ratingDecoder)
            (Decode.field "statement" Decode.string)
        , Decode.map (Tuple.pair Neutral)
            (Decode.field "statement" Decode.string)
        ]

    ratingDecoder : Decoder Rating
    ratingDecoder =
      Decode.string |> Decode.andThen (\r ->
        case r of
          "Strongly Disagree" -> Decode.succeed StronglyDisagree
          "Disagree"          -> Decode.succeed Disagree
          "Somewhat Disagree" -> Decode.succeed SomewhatDisagree
          "Neutral"           -> Decode.succeed Neutral
          "Somewhat Agree"    -> Decode.succeed SomewhatAgree
          "Agree"             -> Decode.succeed Agree
          "Strongly Agree"    -> Decode.succeed StronglyAgree
          _                   -> Decode.fail r
      )

  in
  Decode.map4 LikertScale
    (Decode.field "title" Decode.string)
    (Decode.field "description" Decode.string)
    (Decode.field "statements" <| Decode.list statementDecoder)
    (Decode.field "ratings" <| Decode.list ratingDecoder)