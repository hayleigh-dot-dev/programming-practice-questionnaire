import { Elm } from './elm/Main.elm'

const demographics = [
  {
    type: 'SingleResponse',
    question: 'How old are you?',
    response: null,
    options: [
      { type: 'Fixed', text: 'Under 18' },
      { type: 'Fixed', text: '18-24 years old' },
      { type: 'Fixed', text: '25-34 years old' },
      { type: 'Fixed', text: '35-44 years old' },
      { type: 'Fixed', text: '45-54 years old' },
      { type: 'Fixed', text: 'Over 55' }
    ]
  },
  {
    type: 'SingleResponseWithOther',
    question: 'What is your highest level of education achieved?',
    response: null,
    options: [
      { type: 'Fixed', text: 'Less than A-levels (UK) or a high school diploma (US)' },
      { type: 'Fixed', text: 'A-levels (URK), high school diploma (US), or equivalent' },
      { type: 'Fixed', text: 'Bachelor\'s Degree' },
      { type: 'Fixed', text: 'Master\'s Degree' },
      { type: 'Fixed', text: 'Doctorate' }
    ]
  },
  {
    type: 'SingleResponseWithOther',
    question: 'What was your primary field of study?',
    response: null,
    options: [
      { type: 'Fixed', text: 'Computer Science, Software Engineering, or related fields' },
      { type: 'Fixed', text: 'Music, Music Technology, or related fields' }
    ]
  },
  {
    type: 'MultipleResponseWithOther',
    question: 'Which of the following languages or frameworks have you used for creating interactive audio applications?',
    response: [],
    options: [
      { type: 'Fixed', text: 'AudioKit [Swift]' },
      { type: 'Fixed', text: 'Csound' },
      { type: 'Fixed', text: 'FAUST' },
      { type: 'Fixed', text: 'JUCE [C++]' },
      { type: 'Fixed', text: 'Max/MSP' },
      { type: 'Fixed', text: 'Processing' },
      { type: 'Fixed', text: 'Pure Data' },
      { type: 'Fixed', text: 'Reaktor' },
      { type: 'Fixed', text: 'SuperCollider' },
      { type: 'Fixed', text: 'Web Audio API [JavaScript]' }
    ]
  },
  {
    type: 'MultipleResponseWithOther',
    question: 'Which of the following languages or frameworks are you most comfortable using to create interactive audio applications?',
    response: [],
    options: [
      { type: 'Fixed', text: 'AudioKit [Swift]' },
      { type: 'Fixed', text: 'Csound' },
      { type: 'Fixed', text: 'FAUST' },
      { type: 'Fixed', text: 'JUCE [C++]' },
      { type: 'Fixed', text: 'Max/MSP' },
      { type: 'Fixed', text: 'Processing' },
      { type: 'Fixed', text: 'Pure Data' },
      { type: 'Fixed', text: 'Reaktor' },
      { type: 'Fixed', text: 'SuperCollider' },
      { type: 'Fixed', text: 'Web Audio API [JavaScript]' }
    ]
  }
]

const likert = [
  {
    title: 'How well defined is the end goal?',
    description: 'Some programmers have a very clear idea of what the finished piece of software should look like and what it should do. Others take a more exploratory approach. The following statements are about how clearly defined the end-goal of a project is before you start programming.',
    statements: [
      { statement: 'Before starting to program I have a clear idea what the program will look like.' },
      { statement: 'Before starting to program I have a clear idea how the program will work.' },
      { statement: 'Before starting to program I have a clear idea how to organise my code.' },
      { statement: 'Before starting to program I write down what I need to do.' },
      { statement: 'Before starting to program I sketch or wireframe how the program will look.' }
    ],
    ratings: [
      'Strongly Disagree',
      'Disagree',
      'Neutral',
      'Agree',
      'Strongly Agree'
    ]
  },
  {
    title: 'How much time do you spend on, and how big is, the finished project?',
    description: 'Some programmers work on projects for many months or even years. Others prefer to work on a project for just a matter of days or hours. The following statements are about how long a typical project takes before you consider it complete, and how large the codebase is when it is finished.',
    statements: [
      { statement: 'A typical project takes a significant amount of time to complete.' },
      { statement: 'A finished project’s codebase tends to span multiple files with many lines of code.' },
      { statement: 'I tend to considered a project finished after one programming session.' },
      { statement: 'A finished project’s codebase tends to be made up of one or two files.' }
    ],
    ratings: [
      'Strongly Disagree',
      'Disagree',
      'Neutral',
      'Agree',
      'Strongly Agree'
    ]
  },
  {
    title: 'How much did the project change from beginning to end?',
    description: '',
    statements: [
      { statement: 'A project is only finished when all my tests pass.' },
      { statement: 'Non-critical bugs can lead to unexpected behaviour that makes the project betteror more interesting.' },
      { statement: 'The primary method of interaction has often changed by the time a project is finished.' },
      { statement: 'The primary audio output has often changed by the time a project is finished.' }
    ],
    ratings: [
      'Strongly Disagree',
      'Disagree',
      'Neutral',
      'Agree',
      'Strongly Agree'
    ]
  }
]

const qsort = {
  type: 'Basic',
  title: '',
  description: '',
  statements: [],
  unsorted: [
    {
      key: '01',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '02',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '03',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '04',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '05',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '06',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '07',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '08',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '09',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '10',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '11',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '12',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '13',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '14',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '15',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '16',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '17',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '18',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '19',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '20',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '21',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '22',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '23',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '24',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '25',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '26',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '27',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '28',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '29',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '30',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '31',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '32',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '33',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '34',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '35',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '36',
      title: '',
      image: '',
      rating: 'Neutral',
      description: []
    }
  ]
}

Elm.Main.init({
  flags: { demographics, likert, qsort }
})
