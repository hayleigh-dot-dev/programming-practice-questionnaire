module Data.Tuple exposing
  ( Tuple
  , pairWith
  , from
  , fold
  )

-- Imports ---------------------------------------------------------------------


-- Types -----------------------------------------------------------------------
type alias Tuple a b
  = (a, b)

-- Functions -------------------------------------------------------------------
pairWith : b -> a -> (a, b)
pairWith b a =
  (a, b)

from : a -> (a, a)
from a =
  (a, a)

fold : (a -> b -> c) -> (a, b) -> c
fold f (a, b) =
  f a b