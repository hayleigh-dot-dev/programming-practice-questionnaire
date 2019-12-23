import { Elm } from './elm/Main.elm'

import likert from './json/likert.json'
import qsort from './json/qsort.new.json'

const flags = { 
  likert: JSON.parse(window.localStorage.getItem('likert') || 0) || likert,
  qsort: JSON.parse(window.localStorage.getItem('qsort') || 0) || qsort
}
const node = document.querySelector('[data-elm]')

const app = Elm.Main.init({ node, flags })

window.requestAnimationFrame(() => {
  app.ports.toLocalStorage.subscribe(({ likert, qsort }) => {
    // window.localStorage.setItem('likert', JSON.stringify(likert))
    // window.localStorage.setItem('qsort', JSON.stringify(qsort))
  })
})
