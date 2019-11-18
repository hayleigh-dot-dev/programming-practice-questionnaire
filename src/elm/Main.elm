module Main exposing
  ( ..
  )

-- Imports ---------------------------------------------------------------------
import Browser
import Dict exposing (Dict)
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Set exposing (Set)

import Data.Likert

-- Main ------------------------------------------------------------------------
main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

-- Model -----------------------------------------------------------------------
type alias Flags =
  ()

type alias Model =
  { questionnaire : Dict String Data.Likert.Scale
  }

scaleOne : Data.Likert.Scale
scaleOne =
  let
    title : String
    title = "The extent to which the end-goal is defined."

    description : String
    description = "Some programmers have a very clear idea of what the finished "
      ++ "piece of software should look like and what it should do. Others take a "
      ++ "more exploratory approach. The following statements are about how clearly "
      ++ "defined the end-goal of a project is before you start programming."

    statements : Set String
    statements =
      Set.fromList
        [ "Before starting to program I have a clear idea what the program will look like."
        , "Before starting to program I have a clear idea how the program will work."
        , "Before starting to program I have a clear idea how to organise my code."
        , "Before starting to program I write down what I need to do."
        , "Before starting to program I sketch or wireframe how the program will look."
        ]
  in
  Data.Likert.fivePointScale title description statements

scaleTwo : Data.Likert.Scale
scaleTwo =
  let
    title : String
    title = "The extent of programming effort, over time, and in the size of the resulting codebase"

    description : String
    description = "Some programmers work on projects for many months or even years. "
      ++ "Others prefer to work on a project for just a matter of days or hours. "
      ++ "The following statements are about how long a typical project takes before "
      ++ "you consider it complete, and how large the codebase is when it is finished."

    statements : Set String
    statements =
      Set.fromList
        [ "A typical project takes a significant amount of time to complete."
        , "A finished project’s codebase tends to span multiple files with many lines of code."
        , "I tend to considered a project finished after one programming session."
        , "A finished project’s codebase tends to be made up of one or two files."
        ]
  in
  Data.Likert.fivePointScale title description statements

init : Flags -> ( Model, Cmd Msg )
init flags =
  ( { questionnaire =
        Dict.fromList
          [ ( "The extent to which the end-goal is defined.", scaleOne )
          , ( "The extent of programming effort, over time, and in the size of the resulting codebase", scaleTwo )
          ]
    }
  , Cmd.none
  )

-- Update ----------------------------------------------------------------------
type Msg
  = CheckItem String String Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    CheckItem key statement rating ->
      ( { model 
        | questionnaire = Dict.update key (Maybe.map (Data.Likert.rate statement rating)) model.questionnaire 
        }
      , Cmd.none
      )

-- View ------------------------------------------------------------------------
view : Model -> Html Msg
view model =
  H.main_ [ A.class "container mx-auto" ] (Dict.toList model.questionnaire |> List.map
    (\( k, scale ) -> Data.Likert.toHtml (CheckItem k) scale)
  )

-- Subscriptions ---------------------------------------------------------------
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [
    ]