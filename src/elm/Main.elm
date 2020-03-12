module Main exposing
  ( main
  )

{- Imports ------------------------------------------------------------------ -}
import Browser
import Browser.Dom
import Browser.Navigation
import Html
import Http
import Json.Decode
import Json.Encode
import Set
import Task
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
import Pages.Submission

import Ports.LocalStorage

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
  { errorMessage : Maybe String
  , userConsent : UserConsent
  , userName : String
  , userDate : String
  , userEmail : String
  , emailSubmitted : Bool
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
  | Submission
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
init flags _ key =
  case Json.Decode.decodeValue flagsDecoder flags of
    Ok { demographics, likert, qsort } ->
      ( ( Info
        , key
        , { errorMessage = Nothing
          , userConsent = Data.UserConsent.init
          , userName = ""
          , userDate = ""
          , userEmail = ""
          , emailSubmitted = False
          , demographics = demographics
          , likertScales = likert
          , qsort = qsort
          }
        )
      , Ports.LocalStorage.sequence identity
          |> Ports.LocalStorage.chain (Ports.LocalStorage.read "userData")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.expectJson "userData")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.read "demographics")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.expectJson "demographics")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.read "likert")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.expectJson "likertScales")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.read "qsort")
          |> Ports.LocalStorage.chain (Ports.LocalStorage.expectJson "qsort")
          |> Ports.LocalStorage.commit
      )

    Err e ->
      Tuple.Extra.pairWith Cmd.none <|
        ( Error
        , key
        , { errorMessage = Just (Json.Decode.errorToString e)
          , userConsent = Data.UserConsent.init
          , userName = ""
          , userDate = ""
          , userEmail = ""
          , emailSubmitted = False
          , demographics = []
          , likertScales = []
          , qsort = Data.QSort.init "" "" Set.empty
          }
        )

encodeUserData : Model -> Json.Encode.Value
encodeUserData { userName, userDate, userConsent } =
  Json.Encode.object
    [ ("name", Json.Encode.string userName)
    , ("date", Json.Encode.string userDate)
    , ("consent", Data.UserConsent.encode userConsent)
    ]

encode : Model -> Json.Encode.Value
encode model =
  Json.Encode.object
    [ ("userData", encodeUserData model)
    , ("demographics", Json.Encode.list Data.MultipleChoice.encode model.demographics)
    , ("likertScales", Json.Encode.list Data.Likert.encode model.likertScales)
    , ("qsort", Data.QSort.encode model.qsort)
    ]

encodePartial : Model -> Json.Encode.Value
encodePartial model =
  Json.Encode.object
    [ ("userData", encodeUserData model)
    , ("demographics", Json.Encode.list Data.MultipleChoice.encode model.demographics)
    , ("likertScales", Json.Encode.list Data.Likert.encode model.likertScales)
    ]


{- Update ------------------------------------------------------------------- -}
type Msg
  = None
  | UrlChanged Url
  | InternalUrlRequested Url
  | ExternalUrlRequested String
  -- Localstorage
  | GotUserConsent { name : String, date : String, consent : UserConsent }
  | GotDemographics (List MultipleChoice)
  | GotLikerts (List LikertScale)
  | GotQSort QSort
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
  | EmailUpdated String
  | SubmitEmail
  | GotSubmissionResponse (Result Http.Error ())

update : Msg -> App -> (App, Cmd Msg)
update msg (page, key, model) =
  case msg of
    None ->
      Tuple.pair (page, key, model) Cmd.none

    UrlChanged ({ fragment } as url) ->
      case fragment of
        Just "3" ->
          Tuple.pair (updatePage url, key, model) <| Cmd.batch
            [ Http.post
                { url = "https://qmul-questionnaire.herokuapp.com/partial"
                , body = Http.jsonBody <| encodePartial model
                , expect = Http.expectWhatever GotSubmissionResponse
                }
            , Task.perform (\_ -> None) (Browser.Dom.setViewport 0 0)
            ]

        Just "success" ->
          Tuple.pair (updatePage url, key, model) <| Cmd.batch
            [ Http.post
                { url = "https://qmul-questionnaire.herokuapp.com/complete"
                , body = Http.jsonBody <| encode model
                , expect = Http.expectWhatever GotSubmissionResponse
                }
            , Task.perform (\_ -> None) (Browser.Dom.setViewport 0 0)
            ]

        _ ->
          Tuple.Extra.pairWith (Task.perform (\_ -> None) (Browser.Dom.setViewport 0 0)) <|
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

    GotUserConsent { name, date, consent } ->
      Tuple.Extra.pairWith (Browser.Navigation.pushUrl key "#1") <|
        ( page
        , key
        , { model | userName = name, userDate = date, userConsent = consent }
        )

    GotDemographics demographics ->
      Tuple.Extra.pairWith (Browser.Navigation.pushUrl key "#1") <|
        ( page
        , key
        , { model | demographics = demographics }
        )

    GotLikerts likertScales ->
      Tuple.Extra.pairWith (Browser.Navigation.pushUrl key "#2") <|
        ( page
        , key
        , { model | likertScales = likertScales }
        )

    GotQSort qsort ->
      Tuple.Extra.pairWith (Browser.Navigation.pushUrl key "#3") <|
        ( page
        , key
        , {model | qsort = qsort }
        )


    UserConsentChanged field ->
      let 
        m = { model | userConsent = Data.UserConsent.update field model.userConsent }
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "userData"
        <| encodeUserData m

    UserNameChanged name ->
      let
        m = { model | userName = name }
      in 
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "userData"
        <| encodeUserData m

    UserDateChanged date ->
      let
        m = { model | userDate = date }
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "userData"
        <| encodeUserData m

    OptionSelected i option ->
      let
        m = updateMultipleChoice (Data.MultipleChoice.select option) i model
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "demographics"
        <| Json.Encode.list Data.MultipleChoice.encode m.demographics

    OptionAdded i option ->
      let
        m = updateMultipleChoice (Data.MultipleChoice.add option) i model
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "demographics"
        <| Json.Encode.list Data.MultipleChoice.encode m.demographics

    ItemChecked i statement rating ->
      let
        m = updateLikertScale (Data.Likert.rate statement rating) i model
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "likert"
        <| Json.Encode.list Data.Likert.encode m.likertScales

    ItemSelected statement ->
      let
        m = { model | qsort = Data.QSort.select statement model.qsort }
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "qsort"
        <| Data.QSort.encode model.qsort

    ItemRated rating ->
      let
        m = { model | qsort = Data.QSort.rate rating model.qsort }
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "qsort"
        <| Data.QSort.encode model.qsort

    ItemSorted position ->
      let
        m = { model | qsort = Data.QSort.sort position model.qsort }
      in
      Tuple.pair (page, key, m)
        <| Ports.LocalStorage.commitAction identity
        <| Ports.LocalStorage.write "qsort"
        <| Data.QSort.encode model.qsort

    StepForward ->
      let
        m = { model | qsort = Data.QSort.stepForward model.qsort }
      in
      Tuple.pair (page, key, m) <| Cmd.batch
        [ Ports.LocalStorage.commitAction identity
          <| Ports.LocalStorage.write "qsort"
          <| Data.QSort.encode model.qsort
        , Task.perform (\_ -> None)
          <| Browser.Dom.setViewport 0 0
        ]

    StepBackward ->
      let
        m = { model | qsort = Data.QSort.stepBackward model.qsort }
      in
      Tuple.pair (page, key, m) <| Cmd.batch
        [ Ports.LocalStorage.commitAction identity
          <| Ports.LocalStorage.write "qsort"
          <| Data.QSort.encode model.qsort
        , Task.perform (\_ -> None)
          <| Browser.Dom.setViewport 0 0
        ]


    EmailUpdated email ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , { model | userEmail = email  }
        )

    SubmitEmail ->
      let
        m = { model | emailSubmitted = True }
      in
      Tuple.pair (page, key, m) <| Http.post
        { url = "https://qmul-questionnaire.herokuapp.com/email"
        , body = Http.jsonBody <|
            Json.Encode.object
              [ ("userName", Json.Encode.string model.userName)
              , ("userDate", Json.Encode.string model.userDate)
              , ("userEmail", Json.Encode.string model.userEmail)
              ]
        , expect = Http.expectWhatever GotSubmissionResponse
        }

    GotSubmissionResponse _ ->
      Tuple.Extra.pairWith Cmd.none <|
        ( page
        , key
        , model
        )

updatePage : Url -> Page
updatePage { fragment } =
  case fragment of
    Nothing         -> Info
    Just "info"     -> Info
    Just "consent"  -> Consent
    Just "1"        -> Demographics
    Just "2"        -> Likert
    Just "3"        -> QSort
    Just "success"  -> Submission
    Just _          -> Error

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
title prefix =
  prefix ++ " – Understanding Programming Practice in Audio Software Programming"

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
            }
      }

    Submission ->
      { title = title "Success"
      , body =
          Pages.Submission.view model
            { update = EmailUpdated
            , submit = SubmitEmail
            }
      }

    Error ->
      { title = title "Error"
      , body =
          [ Html.text <| Maybe.withDefault "Decode error" model.errorMessage ]
      }

{- Subscriptions ------------------------------------------------------------ -}
subscriptions : App -> Sub Msg
subscriptions _ =
  let
    userDataDecoder =
      Json.Decode.map3 (\name date consent -> { name = name, date = date, consent = consent })
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "date" Json.Decode.string)
        (Json.Decode.field "consent" Data.UserConsent.decoder)
  in
  Sub.batch
      [ Ports.LocalStorage.onResponse identity (\response ->
          case response of
            Ports.LocalStorage.GotJson "userData" json ->
              Json.Decode.decodeValue userDataDecoder json
                |> Result.map GotUserConsent
                |> Result.withDefault None

            Ports.LocalStorage.GotJson "demographics" json ->
              Json.Decode.decodeValue (Json.Decode.list Data.MultipleChoice.decoder) json
                |> Result.map GotDemographics
                |> Result.withDefault None

            Ports.LocalStorage.GotJson "likertScales" json ->
              Json.Decode.decodeValue (Json.Decode.list Data.Likert.decoder) json
                |> Result.map GotLikerts
                |> Result.withDefault None

            Ports.LocalStorage.GotJson "qsort" json ->
              Json.Decode.decodeValue Data.QSort.decoder json
                |> Result.map GotQSort
                |> Result.withDefault None

            _ ->
              None
        )
      ]
