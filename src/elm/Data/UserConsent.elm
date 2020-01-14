module Data.UserConsent exposing
  ( UserConsent, Field
  , init
  , update
  , hasUserConsent
  , toHtml
  )

{- Imports ------------------------------------------------------------------ -}
import Html exposing (Html)
import Html.Attributes
import Html.Events

{- Types -------------------------------------------------------------------- -}
type alias UserConsent =
  -- I agree that the research project named above has been explained to me to
  -- my satisfaction in verbal and/or written form
  { explained : Bool
  -- I understand that if I decide at any other time during the research that I 
  -- no longer wish to participate in this project, I can notify the researchers 
  -- involved and be withdrawn from it immediately
  , withdrawal : Bool
  -- I have read both the notes written above and the Information Sheet about 
  -- the project, and understand what the research study involves
  , understand : Bool
  -- I agree to take part in the study, which will include use of my personal data
  , personalData : Bool
  }

type Field
  = Explained
  | Withdrawal
  | Understand
  | PersonalData

{- Functions ---------------------------------------------------------------- -}
init : UserConsent
init =
  { explained = False
  , withdrawal = False
  , understand = False
  , personalData = False
  }

update : Field -> UserConsent -> UserConsent
update field ({explained, withdrawal, understand, personalData } as consent) =
  case field of
    Explained ->
      { consent | explained = not explained }

    Withdrawal ->
      { consent | withdrawal = not withdrawal }

    Understand ->
      { consent | understand = not understand }

    PersonalData ->
      { consent | personalData = not personalData }

hasUserConsent : UserConsent -> Bool
hasUserConsent { explained, withdrawal, understand, personalData } =
  explained && withdrawal && understand && personalData

{- View --------------------------------------------------------------------- -}
toHtml : (Field -> msg) -> UserConsent -> Html msg
toHtml handler { explained, withdrawal, understand, personalData } =
  Html.section 
    [ Html.Attributes.class "my-4" ]
    [ Html.div 
      [ Html.Attributes.class "flex" ]
      [ Html.input 
        [ Html.Attributes.class "flex-shrink mr-4"
        , Html.Attributes.type_ "checkbox"
        , Html.Attributes.checked explained
        , Html.Events.onClick (Explained |> handler)
        ] []
      , Html.span 
        [ Html.Attributes.class "flex-1" ]
        [ Html.text
          <| "I agree that the research project named above has been explained to me to "
          ++ "my satisfaction in verbal and/or written form."
        ]
      ]
    , Html.div 
      [ Html.Attributes.class "flex" ]
      [ Html.input 
        [ Html.Attributes.class "flex-shrink mr-4"
        , Html.Attributes.type_ "checkbox"
        , Html.Attributes.checked withdrawal
        , Html.Events.onClick (Withdrawal |> handler)
        ] []
      , Html.span 
        [ Html.Attributes.class "flex-1" ]
        [ Html.text
            <| "I understand that if I decide at any other time during the research that I "
            ++ "no longer wish to participate in this project, I can notify the researchers "
            ++ "involved and be withdrawn from it immediately."
        ]
      ]
    , Html.div 
      [ Html.Attributes.class "flex" ]
      [ Html.input 
        [ Html.Attributes.class "flex-shrink mr-4"
        , Html.Attributes.type_ "checkbox"
        , Html.Attributes.checked understand
        , Html.Events.onClick (Understand |> handler)
        ] []
      , Html.span 
        [ Html.Attributes.class "flex-1" ]
        [ Html.text
            <| "I have read both the notes written above and the Information Sheet about "
            ++ "the project, and understand what the research study involves"
        ]
      ]
    , Html.div 
      [ Html.Attributes.class "flex" ]
      [ Html.input 
        [ Html.Attributes.class "flex-shrink mr-4"
        , Html.Attributes.type_ "checkbox"
        , Html.Attributes.checked personalData
        , Html.Events.onClick (PersonalData |> handler)
        ] []
      , Html.span 
        [ Html.Attributes.class "flex-1" ]
        [ Html.text 
            <| "I agree to take part in the study, which will include use of my "
            ++ "personal data"
        ]
      ]
    ]