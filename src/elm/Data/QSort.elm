module Data.QSort exposing
  ( ..
  )

-- Imports ---------------------------------------------------------------------
import Set exposing (Set)

-- Types -----------------------------------------------------------------------
type alias InitialSort =
  { negative : List String
  , neutral : List String
  , positive : List String
  , unsorted : List String
  }

type alias QuasiNormalSort =
  { initialSort : InitialSort
  , midpoint : Int
  }

-- Constants -------------------------------------------------------------------
type InitialCategory
  = Negative
  | Neutral
  | Positive

-- Functions -------------------------------------------------------------------
createInitialSort : Set String -> InitialSort
createInitialSort items =
  { negative = []
  , neutral = []
  , positive = []
  , unsorted = Set.toList items
  }

initialSortItem : String -> InitialCategory -> InitialSort -> InitialSort
initialSortItem item category sort =
  if List.member item sort.unsorted then
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

  else
    sort

fromInitialSort : InitialSort -> QuasiNormalSort
fromInitialSort ({ negative, neutral, positive } as sort) =
  { initialSort = sort
  , midpoint =
    List.length negative + List.length neutral + List.length positive
      |> toFloat
      |> sqrt
      |> round
  }