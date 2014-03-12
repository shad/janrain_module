# Code Style

## Pretty Cut and Dry

* 120 character lines, max, except URLs which are alone on a single line and exceed that character limit
* Curly braces opening method definitions go on the line following the signature (e.g. K&R style)
* Multi-line message sends align the first colon of each line
* Dictionary & array literals have their opening braces on the ... ? line
* Must be iOS 5 compatible
* 4 space indents
* Spaces, not tabs
* Practice information hiding
* Declare protocol conformation in private categories

## Subjective Areas

* Properties are better than ivars~
* Keep public interfaces as small as reasonably possible
* Do not use compiler directives unless necessary
* Try to push side effects up the call stack
* Name symbols literally accurately (e.g. doesWhatItSaysOnTheTin)
* Methods should begin with verbs
* One class per file~
* Avoid global variables
* Parameterize state

## Poorly Defined Areas

* Fall back to the jump.android coding convetion if something is poorly defined
* Avoid import chaining (e.g. headers should not import other headers, except to define base classes)
