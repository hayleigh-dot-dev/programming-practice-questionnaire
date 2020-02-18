import { Elm } from './elm/Main.elm'

import demographics from './data/demographics'
import likert from './data/likert'
import qsort from './data/qsort'

// t test non parametric

const app = Elm.Main.init({
  flags: { demographics, likert, qsort }
})

app.ports.elmToLocalStorage.subscribe(
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
