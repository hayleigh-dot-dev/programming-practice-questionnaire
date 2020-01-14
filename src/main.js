import { Elm } from './elm/Main.elm'

import likert from './json/likert.json'
import qsort from './json/qsort.new.json'

const flags = {
  likert: JSON.parse(window.localStorage.getItem('likert') || 0) || likert,
  qsort: JSON.parse(window.localStorage.getItem('qsort') || 0) || qsort
}

const app = Elm.Main.init({ flags })
