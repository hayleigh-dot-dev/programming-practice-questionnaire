export const singleResponse = (question, options) => ({
  type: 'SingleResponse',
  question: question,
  response: null,
  options: options.map(text => ({ text, type: 'Fixed' }))
})

export const singleResponseWithOther = (question, options) => ({
  type: 'SingleResponseWithOther',
  question: question,
  response: null,
  options: options.map(text => ({ text, type: 'Fixed' }))
})

export const multipleResponse = (question, options) => ({
  type: 'MultipleResponse',
  question: question,
  response: [],
  options: options.map(text => ({ text, type: 'Fixed' }))
})

export const multipleResponseWithOther = (question, options) => ({
  type: 'MultipleResponseWithOther',
  question: question,
  response: [],
  options: options.map(text => ({ text, type: 'Fixed' }))
})

export const demographics = [
  singleResponse('How old are you?', [
    'Under 18',
    '18-24 years old',
    '25-34 yearw old',
    '45-54 years old',
    'Over 55'
  ]),
  singleResponseWithOther('What is your highest level of education achieved', [
    'Less than A-levels (UK) or a high school diploma (US)',
    'A-levels (URK), high school diploma (US), or equivalent',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate'
  ]),
  multipleResponseWithOther('What was/is your primary field of study?', [
    'Computer Science, Software Engineering, or related field of study',
    'Music, Music Technology, or related field of study'
  ]),
  singleResponse('How many years experience do you have programming?', [
    'Less than 1 year',
    '1 to 2 years',
    '2 to 5 years',
    'Over 5 years'
  ]),
  singleResponse('How many years experience do you have writing interactive audio software specifically?', [
    'Less than 1 year',
    '1 to 2 years',
    '2 to 5 years',
    'Over 5 years'
  ]),
  multipleResponseWithOther('Which of the following languages or frameworks have you used for creating interactive audio software?', [
    'AudioKit [Swift]',
    'Csound',
    'FAUST',
    'JUCE [C++]',
    'Max/MSP',
    'Processing',
    'Pure Data',
    'Reaktor',
    'SuperCollider',
    'Web Audio API [JavaScript]'
  ]),
  singleResponseWithOther('Which of the following languages or frameworks do you have the most experience creating interactive audio software with?', [
    'AudioKit [Swift]',
    'Csound',
    'FAUST',
    'JUCE [C++]',
    'Max/MSP',
    'Processing',
    'Pure Data',
    'Reaktor',
    'SuperCollider',
    'Web Audio API [JavaScript]'
  ])
]

export default demographics
