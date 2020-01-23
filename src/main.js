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
  title: 'Programming Language Features',
  description: `In the two-part task below you'll need to rate various programming
  language features according to positively or negatively they impact your
  programming practice. In the second portion of the task you'll then be asked to
  order the statements from "Most negatively impactful" through "Not impactful" to
  "Most positively impactful". Each language feature has a brief description and
  sometimes an example image or code snippet. If you're unsure how to rate a feature
  rate it as Neutral.`,
  statements: [],
  unsorted: [
    {
      key: '01',
      title: 'The ability to restrict or constrain function arguments',
      image: 'images/01-dependent-types.png',
      rating: 'Neutral',
      description: [
        `Known as "dependent typing", this type system allows a type's definition
        to depend on a value.`,
        `In the example above, the factorial function is defined. It takes one
        argument, an integer, but has an additional constraint applied to it. The
        factorial function can only be called with natural numbers: numbers
        greater than zero.`,
        `Attempting to call factorial(-1) would result in a compile-time error
        meaning less run-time code is dedicated to input validation.`
      ]
    },
    {
      key: '02',
      title: 'Objects with the same members or structure may be used interchangeably',
      image: 'images/02-structural-typing.png',
      rating: 'Neutral',
      description: [
        `Known as "structural typing", this system allows objects to be considered
        equal if they share the same members.`,
        `In the code snippet above, values of both the Person and Employee types
        can be passed to the greet function as they both have a "name" field.`
      ]
    },
    {
      key: '03',
      title: 'The language has tagged union types to describe variants of a single type',
      image: 'images/03-sum-types.png',
      rating: 'Neutral',
      description: [
        `Tagged unions, also known as "disjoint unions" are used to describe
        a value that can take several different, but fixed, types. A special tag
        is used to explicitly indicate which variant a value currently is.`,
        `A traditional enum could be considered the most basic example of a tagged
        union. Each member of the enum is a distinct tag such as Red, Orange, and
        Green in the example above.`,
        `Each variant in the union can also store differing pieces data, as is the
        case in the AudioNode example. The Oscillator variant holds Float values
        for frequency and phase, while the Gain variant holds a single Float value
        for amount.`,
        `Finally, tagged unions can be parameterised for generic use of the type.
        The Result type defined above has two variants, Success and Error, and two
        type parameters, e and a. Depending on the needs of the programmer, types
        such as "Result String Int" can now be used to indicate a value that may
        be an error string or an integer.`
      ]
    },
    {
      key: '04',
      title: 'The language has untagged union types to unify several existing types',
      image: 'images/04-union-types.png',
      rating: 'Neutral',
      description: [
        `Similar to disjoint unions, untagged unions describe a value that can be
        one of sevaral types. As the name implies, untagged unions do not "tag"
        each variant.`,
        `Untagged unions are used to say a value could be of type a OR type b, as
        in the example above. The C code above defines a union of an int and a
        float, and provides a mechanism to access either value. A similar thing
        can be acheived in typescript, for example: "type foo = number | string".`
      ]
    },
    {
      key: '05',
      title: 'Types are dynamic and determined at run-time',
      image: 'images/05-dynamic-typing.png',
      rating: 'Neutral',
      description: [
        `In dynamically typed languages, types are fluid and determined while the
        program is running.`,
        `This makes it easy for developers to maniupulate and transform values,
        but comes at the cost of having to check types manually at runtime.`,
        `The snippet above shows how to check the type of a variable in javascript,
        and shows that the type of a variable can change over it's lifetime.`
      ]
    },
    {
      key: '06',
      title: 'The language has a static type system that determines type correctness at compile-time',
      image: 'images/06-static-typing.png',
      rating: 'Neutral',
      description: [
        `In statically typed languages, the type of a value is determined at compile
        time and the compiler performs checks to ensure all the types in a program
        match up.`,
        `Attempting to call a function that only takes integers with a string for
        example, will result in a compile time error forcing the developer to fix
        the problem.`,
        `Some languages require all values and functions to have "type annotations"
        whereas others can infer types based on their useage while still enforcing
        correctness.`
      ]
    },
    {
      key: '07',
      title: 'The language has an undefined and/or null type and value',
      image: 'images/07-undefined-and-null.png',
      rating: 'Neutral',
      description: [
        `Some languages have the notion of "undefined" or "null" (or both) to
        describe values that do not exist.`,
        `In javascript undefined is returned when trying to access object properties
        that do not exist, and null is used to explicitly describe something with
        no value.`,
        `In the snippet above, the greet function checks if the object has the
        property "name" and uses that in the greeting if it exists. If no element
        has the id "superCoolElement", then null is returned and so this should
        be checked before trying to do anything with the "el" variable.`
      ]
    },
    {
      key: '08',
      title: 'Run-time errors are encoded at the type level and handled as normal values',
      image: 'images/08-error-types.png',
      rating: 'Neutral',
      description: [
        `In some languages such as Java, errors are represented as "exceptions"
        that are thrown and must be caught to prevent the program from crashing.
        In other languages however, errors are represented as values like any
        other and can be manipulated and passed around as normal.`,
        `The Result type above demonstrates this. Instead of throwing an exception,
        the Result type describes a computation that might fail, and forces the
        developer to handle both cases whenever validating a month number.`
      ]
    },
    {
      key: '09',
      title: 'The language supports code macros',
      image: 'images/09-macros.png',
      rating: 'Neutral',
      description: [
        `Some languages support macros as a means of generating or inserting
        bits of code into an existing piece of code. The code snippet above is
        an example of a macro in C. When the compiler comes across any instances
        of the word "double", it expands and inserts the macro into the source
        code and then compiles that new piece of code instead.`,
        `Lisp takes this concept even further, allowing lisp programs themselves
        to manipulate macros, and so functions can be written to generate macros
        at run-time.`
      ]
    },
    {
      key: '10',
      title: 'The language supports reflection and/or introspection',
      image: 'images/10-reflection-and-introspection.png',
      rating: 'Neutral',
      description: [
        `Languages that support reflection and/or introspection are capable of
        examining a program at run-time. In doing so, these programs are able to
        modify their own structure or behaviour, defining new types and inspecting
        the type or properties of values at run-time.`,
        `The above Java snippet gets all the methods defined in MyClass, and
        prints their names to the console. Reflection is particularly useful for
        serialising objects into a format such as JSON.`
      ]
    },
    {
      key: '11',
      title: `The language has a comprehensive standard library covering areas such as 
      UI, graphics, networking, and more complex audio constructs`,
      image: '',
      rating: 'Neutral',
      description: [
        `The language provides packages or modules for a wide variety of programming
        tasks as part of it's standard library.`,
        `These could include packages for creating and displaying user interfaces,
        handling network requests, drawing graphics to the screen, or higher-level
        audio elements such as complete synthesisers.`
      ]
    },
    {
      key: '12',
      title: 'Public packages must following the Semantic Versioning standard',
      image: 'images/12-semantic-versioning.png',
      rating: 'Neutral',
      description: [
        `Some languages have tighter control on their package ecosystem. Elm uses
        it's type system to analyse updates to packages and automatically works
        out how to bump the package version.`,
        `Semantic Versioning is a versioning standard that splits splits software
        versions into MAJOR.MINOR.PATCH numbers such as 1.1.0. This serves as a
        "contract" to consumers of a package, meaning that changes to a package's
        API must result in a MAJOR version increase.`
      ]
    },
    {
      key: '13',
      title: 'The ability to evaluate strings as source code at run-time',
      image: 'images/13-eval.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '14',
      title: 'Code testing is built into the language',
      image: 'images/14-first-class-tests.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '15',
      title: 'Public packages must be fully documented before they are published',
      image: 'images/15-documentation.png',
      rating: 'Neutral',
      description: [
        `In many languages it is a common convention to have special documentation
        comments, such as the popular JavaDoc style, to provide structured
        documentation for a function or package.`,
        `Some package repositories require the presence of these special comments
        in any exposed function or class to help developers and consumers of the
        package.`
      ]
    },
    {
      key: '16',
      title: 'The language has an online editor or playground',
      image: 'images/16-online-editor.png',
      rating: 'Neutral',
      description: [
        `An online editor or playground allows developers to experiment with the
        language without downloading anything or setting up any tooling.`,
        `It can also serve as a convinient scratchpad to quickly test ideas without
        the bloat of a full editor or ide.`
      ]
    },
    {
      key: '17',
      title: `There is an official formatter that formats source code to conform
      with a fixed style guide`,
      image: '',
      rating: 'Neutral',
      description: [
        `It is not uncommon for there to be differing opinions among developers
        around how source code should be written and formatted. So-called linters
        exist to enforce a specific code style within a team or community.`,
        `Recently, languages have started provided official linters so that the
        entire community conforms to a single style guide. This can be seen in
        languages such as Go, Rust, and Elm.`
      ]
    },
    {
      key: '18',
      title: 'Programs can be constructed in a visual patcher environment',
      image: 'images/18-visual-patcher.png',
      rating: 'Neutral',
      description: [
        `Some languages are visual rather than textual. Individual objects or
        functions are connected together with wires in a visual "patcher" environment
        that displays the flow of data in the program.`
      ]
    },
    {
      key: '19',
      title: `There is an explorer for common and/or useful snippets of code,
      objects, or functions`,
      image: 'images/19-explorer.jpg',
      rating: 'Neutral',
      description: [
        ''
      ]
    },
    {
      key: '20',
      title: 'Functions and packages can be searched for based on their type signature',
      image: 'images/20-type-search.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '21',
      title: `There is an official linter that detects common problems and anti-patterns
      such as unused imports or duplicate variable names`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '22',
      title: 'User interfaces can be built using a drag-and-drop editor',
      image: 'images/22-gui-editor.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '23',
      title: 'All values are immutable and cannot be modified',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '24',
      title: 'Functions are pure and do not perform side effects',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '25',
      title: `Functions are first-class values and can be stored in variables
      and passed as arguments to other functions`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '26',
      title: 'Variable names cannot be shadowed',
      image: 'images/26-shadowing.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '27',
      title: 'The language supports objects with local properties and methods',
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '28',
      title: `The language enforces a specific type of application structure or
      architecture`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '29',
      title: `A program can be edited while it is running and changes are reflected
      in real-time`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '30',
      title: `There is a foreign function interface (FFI) to call functions written
      in different languages`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '31',
      title: `Functions can be partially applied by supplying on some of it's
      arguments`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '32',
      title: 'The language has a different syntax for different parts of a program',
      image: 'images/32-different-syntax.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '33',
      title: `Compiler errors have a specific error code associated with them that
      can be used to find out more information about a particular error`,
      image: 'images/33-error-codes.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '34',
      title: 'The compiler provides suggestions on how to fix a compiler error',
      image: 'images/34-compiler-suggestions.png',
      rating: 'Neutral',
      description: []
    },
    {
      key: '35',
      title: `Compiler errors link directly to the portion of source code that
      caused the error`,
      image: '',
      rating: 'Neutral',
      description: []
    },
    {
      key: '36',
      title: `Code can be compiled in a debug mode that allows events to be
      rewound and stepped through in time`,
      image: '',
      rating: 'Neutral',
      description: []
    }
  ]
}

Elm.Main.init({
  flags: { demographics, likert, qsort }
})
