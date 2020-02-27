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
    '25-34 years old',
    '35-44 years old',
    '45-54 years old',
    'Over 55'
  ]),
  singleResponse('What is the highest educational qualification you have attained?', [
    'Did not complete any school qualification',
    'Completed first school qualification at about 16 years (e.g.  GCSE/Junior High School)',
    'Completed Second qualification (e.g A levels/ High School)',
    'Undergraduate degree or professional qualification',
    'Master\'s or taught postgraduate degree',
    'Doctorate or reserach postgraduate degree'
  ]),
  singleResponse('If you are still in education, what is the highest qualification you expect to obtain?', [
    'First school qualification (e.g.  GCSE / Junior High School)',
    'Post-16 vocational course',
    'Second school qualification (e.g.  A-levels / High School)',
    'Undergraduate degree or professional qualification',
    'Master\'s or taught postgraduate degree',
    'Doctorate or reserach postgraduate degree',
    'Not applicable'
  ]),
  multipleResponseWithOther('What was/is your primary field of study?', [
    'Computer Science, Software Engineering, or related field of study',
    'Music, Music Technology, or related field of study'
  ]),
  singleResponse('What is your current occupational status?', [
    'Student',
    'In full-time employment – audio software related',
    'In full-time employment – not audio software related',
    'In part-time employment – audio software related',
    'In part-time employment – not audio software related',
    'Self-employed – audio software related',
    'Self-employed – not audio software related',
    'Homemaker / full-time parent',
    'Unemployed',
    'Retired'
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
