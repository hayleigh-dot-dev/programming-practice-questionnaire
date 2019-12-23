port module Main exposing
  ( main
  )

-- Imports ---------------------------------------------------------------------
import Browser
import Data.Likert exposing (LikertScale)
import Data.Tuple as Tuple exposing (Tuple)
import Data.QSort exposing (QSort)
import Html as H exposing (Html)
import Html.Attributes as A
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Ui.Section

-- Ports -----------------------------------------------------------------------
port toLocalStorage : Encode.Value -> Cmd msg

-- Main ------------------------------------------------------------------------
main : Program Decode.Value (Result Decode.Error Model) Msg
main =
  Browser.element
    { init = init
    , update = update
    , view = Result.map view >> Result.withDefault viewError
    , subscriptions = Result.map subscriptions >> Result.withDefault Sub.none
    }

-- Model -----------------------------------------------------------------------
type alias Flags =
  { likert : List LikertScale
  , qsort : QSort
  }

flagsDecoder : Decoder Flags
flagsDecoder =
  Decode.map2 Flags
    (Decode.field "likert" <| Decode.list Data.Likert.decoder)
    (Decode.field "qsort" Data.QSort.decoder)

type alias Model =
  { likert : List LikertScale
  , qsort : QSort
  }

encodeModel : Model -> Encode.Value
encodeModel { likert, qsort } =
  Encode.object
    [ ("likert", Encode.list Data.Likert.encode likert)
    , ("qsort", Data.QSort.encode qsort)
    ]

init : Decode.Value -> Tuple (Result Decode.Error Model) (Cmd Msg)
init flags =
  Decode.decodeValue flagsDecoder flags
    |> Tuple.pairWith Cmd.none    

-- Update ----------------------------------------------------------------------
type Msg
  = Check Int String Data.Likert.Rating
  | Select Data.QSort.Statement
  | Rate Data.QSort.Rating
  | Sort Int
  | StepForward
  | StepBackward

update : Msg -> Result Decode.Error Model -> Tuple (Result Decode.Error Model) (Cmd Msg)
update msg model =
  case msg of
    Check i statement rating ->
      Result.map (updateLikert (Data.Likert.rate statement rating) i) model
        |> Tuple.from
        |> Tuple.mapSecond (Result.map (encodeModel >> toLocalStorage) >> Result.withDefault Cmd.none)

    Select item ->
      Result.map (updateQSort (Data.QSort.select item)) model
        |> Tuple.from
        |> Tuple.mapSecond (Result.map (encodeModel >> toLocalStorage) >> Result.withDefault Cmd.none)


    Rate rating ->
      Result.map (updateQSort (Data.QSort.rate rating)) model
        |> Tuple.from
        |> Tuple.mapSecond (Result.map (encodeModel >> toLocalStorage) >> Result.withDefault Cmd.none)


    Sort position ->
      Result.map (updateQSort (Data.QSort.sort position)) model
        |> Tuple.from
        |> Tuple.mapSecond (Result.map (encodeModel >> toLocalStorage) >> Result.withDefault Cmd.none)


    StepForward ->
      Result.map (updateQSort Data.QSort.stepForward) model
        |> Tuple.from
        |> Tuple.mapSecond (Result.map (encodeModel >> toLocalStorage) >> Result.withDefault Cmd.none)


    StepBackward ->
      Result.map (updateQSort Data.QSort.stepBackward) model
        |> Tuple.from
        |> Tuple.mapSecond (Result.map (encodeModel >> toLocalStorage) >> Result.withDefault Cmd.none)

updateLikert : (LikertScale -> LikertScale) -> Int -> Model -> Model
updateLikert updateF pos model =
  model.likert 
    |> List.indexedMap (\i scale -> if i == pos then updateF scale else scale)
    |> (\likert -> { model | likert = likert })

updateQSort : (QSort -> QSort) -> Model -> Model
updateQSort updateF model =
  updateF model.qsort
    |> (\qsort -> { model | qsort = qsort })

-- View ------------------------------------------------------------------------
view : Model -> Html Msg
view model =
  H.main_ [ A.class "" ] (List.concat
    [ model.likert
        |> List.indexedMap (\i scale -> Data.Likert.toHtml (Check i) scale)
    , List.singleton model.qsort
        |> List.map (Data.QSort.toHtml
            { selectMsg = Select
            , rateMsg = Rate
            , sortMsg = Sort
            , stepForward = StepForward
            , stepBackward = StepBackward
            }
        )
    ]
  )

viewError : Html Msg
viewError =
  H.main_ [ A.class "" ]
    [ Ui.Section.standard "Oops, something went wrong!" ""
      []
      []
    ]

-- Subscriptions ---------------------------------------------------------------
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [
    ]