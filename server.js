const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')

const send = require('gmail-send')({
  user: 'andalarct@gmail.com',
  pass: process.env.GMAIL_TOKEN,
  to: 'andrew.thompson@qmul.ac.uk'
})

const app = express()
const port = process.env.PORT || 3000

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))

app.listen(port, () => {
  console.log(`✨Server running on port ${port}.`)
})

// The incoming json is expected to have all these keys present to be considered
// valid
const keys = ['userData', 'demographics', 'likertScales', 'qsort']
// Takes the above keys and validates an object based on whether all these keys
// are present. We *don't* validate the value of these keys, just their
// existence.
const validate = (obj, keys) => Object
  .keys(obj)
  .reduce((valid, key) => valid && keys.includes(key), true)

app.post('/partial', (request, response) => {
  const json = request.body
  const isValid = validate(json, keys.filter(k => k !== 'qsort'))
  if (isValid) {
    const body = JSON.stringify(json, null, 2)

    send({
      subject: `New Questionnaire Partial Response: ${json.userName} – ${json.userDate}`,
      text: body
    })

    response.sendStatus(200)
  } else {
    console.log(`Invalid json: ${console.dir(json)}`)

    response.sendStatus(418)
  }
})

app.post('/complete', (request, response) => {
  const json = request.body
  const isValid = validate(json, keys)

  if (isValid) {
    const body = JSON.stringify(json, null, 2)

    send({
      subject: `New Questionnaire Response: ${json.userName} – ${json.userDate}`,
      text: body
    })

    response.sendStatus(200)
  } else {
    console.log(`Invalid json: ${console.dir(json)}`)

    response.sendStatus(418)
  }
})

app.post('/email', (request, response) => {
  const json = request.body

  if (json.userName && json.userDate && json.userEmail) {
    send({
      subject: `New Questionnaire Email Response: ${json.userName} - ${json.userDate}`,
      body: json.email
    })

    response.sendStatus(200)
  } else {
    response.sendStatus(418)
  }
})
