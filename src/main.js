import { Elm } from './elm/Main.elm'

import demographics from './data/demographics'
import likert from './data/likert'
import qsort from './data/qsort'

// t test non parametric

Elm.Main.init({
  flags: { demographics, likert, qsort }
})
