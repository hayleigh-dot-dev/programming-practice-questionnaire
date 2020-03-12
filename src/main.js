import Main from './elm/Main.elm'
import Results from './elm/Results.elm'

import demographics from './data/demographics'
import likert from './data/likert'
import qsort from './data/qsort'

import complete from './responses/complete/*.json'
import partial from './responses/partial/*.json'

// t test non parametric
const Elm = {
  Main: Main.Elm.Main,
  Results: Results.Elm.Results
}

console.log(window.location.hash)
console.log(Object.values(partial))

const app = window.location.hash === '#results'
  ? Elm.Results.init({
    flags: {
      partial: Object.values(partial),
      complete: Object.values(complete)
    }
  })
  : Elm.Main.init({
    flags: { demographics, likert, qsort }
  })

// LocalStorage port -----------------------------------------------------------
app.ports && app.ports.elmToLocalStorage && app.ports.elmToLocalStorage.subscribe(
  function handleMsg (actions, responses = []) {
    actions.forEach(action => {
      console.log(action)

      switch (action.$) {
        case 'Batch': {
          const batchActions = action.actions

          batchActions.forEach(handleMsg)
          break
        }

        case 'Clear': {
          window.localStorage.clear()
          break
        }

        case 'Expect': {
          const tag = action.tag
          const responseType = action.responseType
          const response = responses.shift()

          console.log(response)

          if (response.type === responseType) {
            app.ports.localStorageToElm.send({
              $: 'GotJson', tag, data: response.data
            })
          } else {
            app.ports.localStorageToElm.send({
              $: 'Error', tag, error: `Type mismatch, expected ${responseType} but got ${response.type}`
            })
          }
          break
        }

        case 'Read': {
          const key = action.key
          const data = window.localStorage.getItem(key)

          responses.push({ type: 'Json', data: data ? JSON.parse(data) : null })
          break
        }

        case 'Write': {
          const key = action.key
          const value = action.value

          window.localStorage.setItem(key, JSON.stringify(value))
          break
        }
      }
    })
  }
)
