module Results exposing
  ( main
  )

{- Imports ------------------------------------------------------------------ -}
import Browser
import Dict exposing (Dict)
import Html
import Json.Decode
import Tuple.Extra exposing (Tuple)

import Data.Likert exposing (LikertScale)
import Data.MultipleChoice exposing (MultipleChoice (..))
import Data.QSort exposing (QSort)


{- Main --------------------------------------------------------------------- -}
{-| -}
main : Program Json.Decode.Value Model Msg
main =
  Browser.document
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


{- Model -------------------------------------------------------------------- -}
{-| -}
type alias Model =
  { partialResponses : List PartialResponse
  , completeResponses : List Response
  }

{-| -}
type alias PartialResponse =
  { demographics : List MultipleChoice
  , likert : List LikertScale
  }

{-| -}
type alias Response =
  { demographics : List MultipleChoice
  , likert : List LikertScale
  , qsort : QSort
  }

{-| -}
init : Json.Decode.Value -> Tuple Model (Cmd Msg)
init flags =
  case Json.Decode.decodeValue flagsDecoder flags of
    Ok { partialResponses, completeResponses } ->
      ( { partialResponses = partialResponses
        , completeResponses = completeResponses
        }
      , Cmd.none
      )

    Err _ ->
      ( { partialResponses = []
        , completeResponses = []
        }
      , Cmd.none
      )

{-| -}
flagsDecoder : Json.Decode.Decoder Model
flagsDecoder =
  Json.Decode.map2 Model
    (Json.Decode.field "partial" (Json.Decode.list partialResponseDecoder))
    (Json.Decode.field "complete" (Json.Decode.list responseDecoder))

{-| -}
partialResponseDecoder : Json.Decode.Decoder PartialResponse
partialResponseDecoder =
  Json.Decode.map2 PartialResponse
    (Json.Decode.field "demographics" (Json.Decode.list Data.MultipleChoice.decoder))
    (Json.Decode.field "likertScales" (Json.Decode.list Data.Likert.decoder))

{-| -}
responseDecoder : Json.Decode.Decoder Response
responseDecoder =
  Json.Decode.map3 Response
    (Json.Decode.field "demographics" (Json.Decode.list Data.MultipleChoice.decoder))
    (Json.Decode.field "likertScales" (Json.Decode.list Data.Likert.decoder))
    (Json.Decode.field "qsort" Data.QSort.decoder)


{- Update ------------------------------------------------------------------- -}
{-| -}
type Msg
  = None

{-| -}
update : Msg -> Model -> Tuple Model (Cmd Msg)
update msg model =
  case msg of
    None ->
      ( model
      , Cmd.none
      )


{- View --------------------------------------------------------------------- -}
{-| -}
view : Model -> Browser.Document Msg
view model =
  { title = ""
  , body =
    [ Html.text "Nothing to see here, move along."
    ]
  }

type alias DemographicData =
  { question : String
  , results : Dict String Int
  }

toDemographicData : List MultipleChoice -> DemographicData
toDemographicData rs =
  let
    updateResults r results =
      results |> Dict.update r (\count ->
        case count of
          Just n ->
            Just (n + 1)

          Nothing ->
            Just 0
      )

    unpackResponse r results =
      case r of
        SingleResponse { response } ->
          Maybe.map Data.MultipleChoice.optionToString response
            |> Maybe.map (\resp -> updateResults resp results)
            |> Maybe.withDefault results

        SingleResponseWithOther { response } ->
          Maybe.map Data.MultipleChoice.optionToString response
            |> Maybe.map (\resp -> updateResults resp results)
            |> Maybe.withDefault results
  
        MultipleResponse { responses } ->
          List.map Data.MultipleChoice.optionToString responses
            |> List.foldl updateResults results

        MultipleResponseWithOther { responses } ->
          List.map Data.MultipleChoice.optionToString responses
            |> List.foldl updateResults results

  in
  case rs of
    (SingleResponse { question }) :: tail ->
      { question = question
      , results = List.foldl unpackResponse Dict.empty rs
      }

    (SingleResponseWithOther { question }) :: tail ->
      { question = question
      , results = List.foldl unpackResponse Dict.empty rs
      }

    (MultipleResponse { question }) :: tail ->
      { question = question
      , results = List.foldl unpackResponse Dict.empty rs
      }

    (MultipleResponseWithOther { question }) :: tail ->
      { question = question
      , results = List.foldl unpackResponse Dict.empty rs
      }

    _ ->
      toDemographicData rs

{- Subscriptions ------------------------------------------------------------ -}
{-| -}
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [
    ]