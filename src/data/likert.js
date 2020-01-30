// Likert scales ---------------------------------------------------------------
export const likertScale = (title, description, statements) => ({
  title: title,
  description: description,
  statements: statements.map(statement => ({ statement })),
  ratings: [
    'Strongly Disagree',
    'Disagree',
    'Neutral',
    'Agree',
    'Strongly Agree'
  ]
})

export const likert = [
  likertScale(
    'In a typical audio programming project, how well defined is the end goal?',
    'Some programmers have a very clear idea of what the finished piece of software should look like and what it should do. Others take a more exploratory approach. The following statements are about how clearly defined the end-goal of a project is before you start programming.',
    [
      'Before starting to program I have a clear idea what the program will look like.',
      'Before starting to program I have a clear idea how the program will work.',
      'Before starting to program I have a clear idea how to organise my code.',
      'Before starting to program I write down what I need to do.',
      'Before starting to program I sketch or wireframe how the program will look.'
    ]
  ),
  likertScale(
    'How much time do you spend on, and how big is, a typical finished audio programming project?',
    'Some programmers work on projects for many months or even years. Others prefer to work on a project for just a matter of days or hours. The following statements are about how long a typical project takes before you consider it complete, and how large the codebase is when it is finished.',
    [
      'A typical project takes a significant amount of time to complete.',
      'A finished project\'s codebase tends to span multiple files and many lines of code.',
      'I tend to consider a project finished after one or two sessions of programming.',
      'A finished project\'s codebase tends to be made up of just one or two files.'
    ]
  ),
  likertScale(
    'How much does a typical audio programming project change from beginning to end?',
    '',
    [
      'I consider a project finished when all my tests pass.',
      'I think non-critical bugs can lead to unexpected behaviour that can make a project better or more interesting.',
      'The primary method of interaction in a program has often changed by the time that project is finished.',
      'The primary audio output of a program has often changed by the time that project is finished.'
    ]
  )
]

export default likert
