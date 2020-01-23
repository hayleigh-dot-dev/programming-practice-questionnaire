module Main exposing
  ( main
  )

{- Imports ------------------------------------------------------------------ -}
import Browser
import Browser.Navigation
import Http
import Json.Decode
import Json.Encode
import Set
import Tuple.Extra
import Url exposing (Url)

import Data.UserConsent exposing (UserConsent)
import Data.Likert exposing (LikertScale)
import Data.MultipleChoice exposing (MultipleChoice)
import Data.QSort exposing (QSort)

import Pages.Info
import Pages.Consent
import Pages.Demographics
import Pages.Likert
import Pages.QSort

{- Main --------------------------------------------------------------------- -}
main : Program Json.Decode.Value App Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = onUrlChange
    , onUrlRequest = onUrlRequest
    }

onUrlChange : Url -> Msg
onUrlChange url =
  UrlChanged url

onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest urlRequest =
  case urlRequest of
    Browser.Internal url ->
      InternalUrlRequested url

    Browser.External url ->
      ExternalUrlRequested url

{- Model -------------------------------------------------------------------- -}
type alias App =
  (Page, Browser.Navigation.Key, Model)

type alias Model =
  { userConsent : UserConsent
  , userName : String
  , userDate : String
  , demographics : List MultipleChoice
  , likertScales : List LikertScale
  , qsort : QSort
  }

type Page
  = Info
  | Consent
  | Demographics
  | Likert
  | QSort
  | Error

type alias Flags =
  { demographics : List MultipleChoice
  , likert : List LikertScale
  , qsort : QSort
  }

flagsDecoder : Json.Decode.Decoder Flags
flagsDecoder =
  Json.Decode.map3 Flags
    (Json.Decode.field "demographics" (Json.Decode.list Data.MultipleChoice.decoder))
    (Json.Decode.field "likert" (Json.Decode.list Data.Likert.decoder))
    (Json.Decode.field "qsort" Data.QSort.decoder)

init : Json.Decode.Value -> Url -> Browser.Navigation.Key -> (App, Cmd Msg)
init flags url key =
  case Json.Decode.decodeValue flagsDecoder flags of
    Ok { demographics, likert, qsort } ->
      Tuple.Extra.pairWith Cmd.none <|
        ( updatePage url
        , key
        , { userConsent = Data.UserConsent.init
          , userName = ""
          , userDate = ""
          , demographics = demographics
          , likertScales = likert
          , qsort = qsort
          }
        )

    Err _ ->
      Tuple.Extra.pairWith Cmd.none <|
        ( Error
        , key
        , { userConsent = Data.UserConsent.init
          , userName = ""
          , userDate = ""
          , demographics = []
          , likertScales = []
          , qsort = Data.QSort.init "" "" Set.empty
          }
        )

encode : Model -> Json.Encode.Value
encode model =
  Json.Encode.object
  [ ("userConsent", Data.UserConsent.encode model.userConsent)
  , ("userName", Json.Encode.string model.userName)
  , ("userDate", Json.Encode.string model.userDate)
  , ("demographics", Json.Encode.list Data.MultipleChoice.encode model.demographics)
  , ("likertScales", Json.Encode.list Data.Likert.encode model.likertScales)
  , ("qsort", Data.QSort.encode model.qsort)
  ]

{- Update ------------------------------------------------------------------- -}
type Msg
  = UrlChanged Url
  | InternalUrlRequested Url
  | ExternalUrlRequested String
  -- Consent Form
  | UserConsentChanged Data.UserConsent.Field
  | UserNameChanged String
  | UserDateChanged String
  -- Demographic Info
  | OptionSelected Int Data.MultipleChoice.Option
  | OptionAdded Int String
  -- Likert Scales
  | ItemChecked Int String Data.Likert.Rating
  -- QSort Exercise
  | ItemSelected Data.QSort.Statement
  | ItemRated Data.QSort.Rating
  | ItemSorted Int
  | StepForward
  | StepBackward
  -- Submission
  | SubmitResponses
  | GotSubmissionResponse (Result Http.Error ())

update : Msg -> App -> (App, Cmd Msg)
update msg (page, key, model) =
  case msg of
    UrlChanged url ->
      Tuple.Extra.pairWith Cmd.none <|
        ( updatePage url
        , key
        , model
        )

    InternalUrlRequested url ->
      Tuple.Extra.pairWith (Browser.Navigation.pushUrl key (Url.toString url)) <|
        ( page
        , key
        , model
        )

    ExternalUrlRequested url ->
      Tuple.Extra.pairWith (Browser.Navigation.load url) <|
        ( page
        , key
        , model
        )

    UserConsentChanged field ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | userConsent = Data.UserConsent.update field model.userConsent }
        )

    UserNameChanged name ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | userName = name }
        )

    UserDateChanged date ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | userDate = date }
        )

    OptionSelected i option ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , model |> updateMultipleChoice (Data.MultipleChoice.select option) i
        )

    OptionAdded i option ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , model |> updateMultipleChoice (Data.MultipleChoice.add option) i
        )

    ItemChecked i statement rating ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , model |> updateLikertScale (Data.Likert.rate statement rating) i 
        )

    ItemSelected statement ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | qsort = Data.QSort.select statement model.qsort }
        )
  
    ItemRated rating ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | qsort = Data.QSort.rate rating model.qsort }
        )
  
    ItemSorted position ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | qsort = Data.QSort.sort position model.qsort }
        )

    StepForward ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | qsort = Data.QSort.stepForward model.qsort }
        )

    StepBackward ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | qsort = Data.QSort.stepBackward model.qsort }
        )

    SubmitResponses ->
      Tuple.pair (page, key, model) <| Http.post
        { url = "http://localhost:3000"
        , body = Http.jsonBody <| encode model
        , expect = Http.expectWhatever GotSubmissionResponse
        }

    GotSubmissionResponse _ ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , model
        )

updatePage : Url -> Page
updatePage { path } =
  case path of
    "/"         -> Info
    "/info"     -> Info
    "/consent"  -> Consent
    "/1"        -> Demographics
    "/2"        -> Likert
    "/3"        -> QSort
    _           -> Error

updateMultipleChoice : (MultipleChoice -> MultipleChoice) -> Int -> Model -> Model
updateMultipleChoice updateF j model =
  model.demographics 
    |> List.indexedMap (\i mc -> if i == j then updateF mc else mc)
    |> (\demographics -> { model | demographics = demographics })

updateLikertScale : (LikertScale -> LikertScale) -> Int -> Model -> Model
updateLikertScale updateF j model =
  model.likertScales 
    |> List.indexedMap (\i scale -> if i == j then updateF scale else scale)
    |> (\likertScales -> { model | likertScales = likertScales })

{- View --------------------------------------------------------------------- -}
title : String -> String
title suffix =
  "Understanding Programming Practice in Audio Software Programming – " ++ suffix

view : App -> Browser.Document Msg
view (page, _, model) =
  case page of
    Info ->
      { title = title "Info"
      , body = 
          Pages.Info.view
      }

    Consent ->
      { title = title "Consent"
      , body = 
          Pages.Consent.view model
            { userConsentChanged = UserConsentChanged
            , userNameChanged = UserNameChanged
            , userDateChanged = UserDateChanged
            }
      }

    Demographics ->
      { title = title "Demographics"
      , body = 
          Pages.Demographics.view model
            { optionSelected = OptionSelected
            , optionAdded = OptionAdded
            }
      }

    Likert ->
      { title = title "Likert Scales"
      , body = 
          Pages.Likert.view model
            { itemChecked = ItemChecked
            }
      }

    QSort ->
      { title = title "QSort Exercise"
      , body = 
          Pages.QSort.view model
            { itemSelected = ItemSelected
            , itemRated = ItemRated
            , itemSorted = ItemSorted
            , stepForward = StepForward
            , stepBackward = StepBackward
            , submit = SubmitResponses
            }
      }

    Error ->
      { title = title "Error"
      , body = []
      }

{- Subscriptions ------------------------------------------------------------ -}
subscriptions : App -> Sub Msg
subscriptions app =
  Sub.none
