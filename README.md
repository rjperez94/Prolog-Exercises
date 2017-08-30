# Prolog-Exercises

## Running the program

To run the Prolog `.pl` files, I used SWI Prolog from <a href='http://www.swi-prolog.org/download/stable'>here</a>. Just install it in your machine and double click a `.pl` file to run

## Contents

### Dr. Roberts

Increasing cost pressure led psychiatrists to replace some of their services with a computer-based system, dubbed `Dr. Roberts`. The application should respond to sentences typed in by a client similar to a real psychiatrist would. 

For instance, the sentence "I feel bad about my brother." should be answered with "What makes you feel bad about your brother?". Dr. Roberts can form the reply by looking for the keyword `feel` and then inserting a transformed version of whatever follows `feel` in the input to the template e.g. "What makes you feel *?". The transformation of the input fragment involves replacing words e.g., `my --> your`, `you --> me`, `am --> are`.

It is sufficient to expect input in the form of lists of atoms, such as `[i, fantasised, about, fast, cars]` (to which Dr. Roberts should reply `[have, you, ever, fantasised, about, fast, cars, before, qm]`). Note that qm is used to represent `?`.

#### Predicates

- `printSentence` takes a list of atoms and writes it out to the standard output, using the predefined predicate `write`. For instance, `printSentence([Why, do, you, like, your, mother, qm])` should result in `"Why do you like your mother ?"`.
- `answer` succeeds if the first argument is an input list of terms and the second is the corresponding reply by Dr. Roberts. For instance, the reply to the input `[i, know, i, am, insecure]` should be `[are, you, sure, you, know, that, you, are, insecure, qm]`.
- `match` used for finding keywords in input lists
- `transform` used for transforming input phrases into the corresponding output fragments
- `printReply` takes an input list and writes the answer to the standard output

### North Island Journey Planner

This New Zealand <a href='https://github.com/rjperez94/Prolog-Exercises/blob/master/connection-data.gif'>data</a> describes the North Island's major road network and the distances between towns.

#### Predicates

- `road` captures the information in `connection-data.gif`. We assume that no town is visited twice
- `route(Start, Finish, Visits)` succeeds if there is a route from Start to Finish visiting the towns in list Visits
- `route(Start, Finish, Visits, Distance)` succeeds if there is a route from Start to Finish, visiting the towns in list Visits, which spans Distance long
- `choice(Start, Finish, RoutesAndDistances)` produces a list of all the routes (including their distances) between Start and Finish
- `via(Start, Finish, Via, RoutesAndDistances)` produce a list of all the routes (including their distances) between Start and Finish which visit towns within Via
- `avoiding(Start, Finish, Avoiding, RoutesAndDistances)` produces a list of all the routes (including their distances) between Start and Finish which do not visit towns within Avoiding
