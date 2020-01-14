module Data.MultipleChoice exposing
  ( ..
  )

{- Imports ------------------------------------------------------------------ -}
import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Json.Decode
import Json.Encode

import Ui.Section

{- Types -------------------------------------------------------------------- -}
type Option
  = Fixed String
  | Other String

type MultipleChoice
  = SingleResponse
    { question : String
    , response : Maybe Option
    , options : List Option
    }
  | SingleResponseWithOther
    { question : String
    , response : Maybe Option
    , options : List Option
    }
  | MultipleResponse
    { question : String
    , responses : List Option
    , options : List Option
    }
  | MultipleResponseWithOther
    { question : String
    , responses : List Option
    , options : List Option
    }

type alias Events msg =
  { optionSelected : Option -> msg
  , optionAdded : String -> msg
  }

{- Functions ---------------------------------------------------------------- -}
initSingleResponse : String -> List String -> MultipleChoice
initSingleResponse question options =
  SingleResponse
    { question = question
    , response = Nothing
    , options = List.map Fixed options
    }

initSingleResponseWithOther : String -> List String -> MultipleChoice
initSingleResponseWithOther question options =
  SingleResponseWithOther
    { question = question
    , response = Nothing
    , options = List.map Fixed options
    }

initMultipleResponse : String -> List String -> MultipleChoice
initMultipleResponse question options =
  MultipleResponse
    { question = question
    , responses = []
    , options = List.map Fixed options
    }

initMultipleResponseWithOther : String -> List String -> MultipleChoice
initMultipleResponseWithOther question options =
  MultipleResponseWithOther
    { question = question
    , responses = []
    , options = List.map Fixed options
    }

select : Option -> MultipleChoice -> MultipleChoice
select option multipleChoice =
  case multipleChoice of
    SingleResponse ({ response, options } as mc) ->
      case option of
        Fixed _ ->
          if response == Just option then
            SingleResponse { mc | response = Nothing }
          else
            SingleResponse { mc | response = Just option }

        Other _ ->
          if response == Just option then
            SingleResponse { mc | response = Nothing, options = List.filter ((==) option) options }
          else
            SingleResponse { mc | response = Just option }

    SingleResponseWithOther ({ response, options } as mc) ->
      case option of
        Fixed _ ->
          if response == Just option then
            SingleResponseWithOther { mc | response = Nothing }
          else
            SingleResponseWithOther { mc | response = Just option }

        Other _ ->
          if response == Just option then
            SingleResponseWithOther { mc | response = Nothing, options = List.filter ((==) option) options }
          else
            SingleResponseWithOther { mc | response = Just option }

    MultipleResponse ({ responses, options } as mc) ->
      case option of
        Fixed _ ->
          if List.member option responses then
            MultipleResponse { mc | responses = List.filter ((/=) option) responses }
          else
            MultipleResponse { mc | responses = option :: responses }

        Other _ ->
          if List.member option responses then
            MultipleResponse
              { mc 
              | responses = List.filter ((/=) option) responses 
              , options = List.filter ((/=) option) options
              }
          else
            MultipleResponse { mc | responses = option :: responses }

    MultipleResponseWithOther ({ responses, options } as mc) ->
      case option of
        Fixed _ ->
          if List.member option responses then
            MultipleResponseWithOther { mc | responses = List.filter ((/=) option) responses }
          else
            MultipleResponseWithOther { mc | responses = option :: responses }

        Other _ ->
          if List.member option responses then
            MultipleResponseWithOther
              { mc 
              | responses = List.filter ((/=) option) responses 
              , options = List.filter ((/=) option) options
              }
          else
            MultipleResponseWithOther { mc | responses = option :: responses }

add : String -> MultipleChoice -> MultipleChoice
add option multipleChoice =
  case multipleChoice of
    SingleResponseWithOther ({ options } as mc) ->
      SingleResponseWithOther { mc | options = options ++ [Other option] }
        |> select (Other option)

    MultipleResponseWithOther ({ options } as mc) ->
      MultipleResponseWithOther { mc | options = options ++ [Other option] }
        |> select (Other option)

    _ ->
      multipleChoice

{- View --------------------------------------------------------------------- -}
toHtml : MultipleChoice -> Events msg -> Html msg
toHtml multipleChoice { optionSelected, optionAdded } =
  case multipleChoice of
    SingleResponse { question, response, options } ->
      Ui.Section.empty
        |> Ui.Section.withTitle question
        |> Ui.Section.addChildren (
          options |> List.map (\o ->
              viewSingleResponse optionSelected (Just o == response) o
          )
        )
        |> Ui.Section.toHtml

    SingleResponseWithOther { question, response, options } ->
      Ui.Section.empty
        |> Ui.Section.withTitle question
        |> Ui.Section.addChildren (
          options |> List.map (\o ->
              viewSingleResponse optionSelected (Just o == response) o
          )
        )
        |> Ui.Section.addChild (
          Html.span
            []
            [ Html.text "Other:"
            , Html.input
              [ Html.Attributes.class "ml-2 my-2"
              , onEnter optionAdded
              ] []
            ]
        )
        |> Ui.Section.toHtml

    MultipleResponse {question, responses, options } ->
      Ui.Section.empty
        |> Ui.Section.withTitle question
        |> Ui.Section.addChildren ( 
          options |> List.map (\o ->
              viewMultipleResponse optionSelected (List.member o responses) o
          )
        )
        |> Ui.Section.toHtml

    MultipleResponseWithOther {question, responses, options } ->
      Ui.Section.empty
        |> Ui.Section.withTitle question
        |> Ui.Section.addChildren ( 
          options |> List.map (\o ->
              viewMultipleResponse optionSelected (List.member o responses) o
          )
        )
        |> Ui.Section.addChild (
          Html.span
            []
            [ Html.text "Other:"
            , Html.input
              [ Html.Attributes.class "ml-2 my-2"
              , onEnter optionAdded
              ] []
            ]
        )
        |> Ui.Section.toHtml

viewSingleResponse : (Option -> msg) -> Bool -> Option -> Html msg
viewSingleResponse optionSelected isSelected option =
  Html.div
    [ Html.Attributes.class "mb-2" ]
    [ Html.input 
      [ Html.Attributes.class "mr-4"
      , Html.Attributes.type_ "radio"
      , Html.Attributes.checked isSelected
      , Html.Events.onClick (optionSelected option)
      ] []
    , Html.span
      []
      [ Html.text (optionToString option) ]
    ]

viewMultipleResponse : (Option -> msg) -> Bool -> Option -> Html msg
viewMultipleResponse optionSelected isSelected option =
  Html.div
    [ Html.Attributes.class "mb-2" ]
    [ Html.input 
      [ Html.Attributes.class "mr-4"
      , Html.Attributes.type_ "checkbox"
      , Html.Attributes.checked isSelected
      , Html.Events.onClick (optionSelected option)
      ] []
    , Html.span
      []
      [ Html.text (optionToString option) ]
    ]

optionToString : Option -> String
optionToString option =
  case option of
    Fixed text ->
      text
    
    Other text ->
      text

{- Events ------------------------------------------------------------------- -}
onEnter : (String -> msg) -> Attribute msg
onEnter handler =
  Html.Events.on "keydown" (
    Json.Decode.field "key" Json.Decode.string
      |> Json.Decode.andThen (\key ->
        if Debug.log "key" key == "Enter" then
          Json.Decode.at [ "target", "value" ] Json.Decode.string
            |> Json.Decode.map handler
        else
          Json.Decode.fail ""
      )
  )

{- JSON --------------------------------------------------------------------- -}
encode : MultipleChoice -> Json.Encode.Value
encode mc =
  case mc of
    SingleResponse { question, response, options } ->
      Json.Encode.object
        [ ("type", Json.Encode.string "SingleResponse")
        , ("question", Json.Encode.string question)
        , ("response", Maybe.map encodeOption response |> Maybe.withDefault Json.Encode.null)
        , ("options", Json.Encode.list encodeOption options)
        ]

    SingleResponseWithOther { question, response, options } ->
      Json.Encode.object
        [ ("type", Json.Encode.string "SingleResponseWithOther")
        ]

    MultipleResponse { question, responses, options } ->
      Json.Encode.object
        [ ("type", Json.Encode.string "MultipleResponse")
        ]

    MultipleResponseWithOther { question, responses, options } ->
      Json.Encode.object
        [ ("type", Json.Encode.string "MultipleResponseWithOther")
        ]

encodeOption : Option -> Json.Encode.Value
encodeOption option =
  case option of
    Fixed text ->
      Json.Encode.object
        [ ("type", Json.Encode.string "Fixed")
        , ("text", Json.Encode.string text)
        ]

    Other text ->
      Json.Encode.object
        [ ("type", Json.Encode.string "Other")
        , ("text", Json.Encode.string text)
        ]