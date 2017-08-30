# Prolog-Exercises

## Running the program

To run the Prolog `.pl` files, I used SWI Prolog from <a href='http://www.swi-prolog.org/download/stable'>here</a>. Just install it in your machine and double click a `.pl` file to run

## Contents

### Dr. Roberts

Increasing cost pressure led psychiatrists to replace some of their services with a computer-based system, dubbed `Dr. Roberts`. The application should respond to sentences typed in by a client similar to a real psychiatrist would. 

For instance, the sentence "I feel bad about my brother." should be answered with "What makes you feel bad about your brother?". Dr. Roberts can form the reply by looking for the keyword `feel` and then inserting a transformed version of whatever follows `feel` in the input to the template e.g. "What makes you feel *?". The transformation of the input fragment involves replacing words e.g., `my --> your`, `you --> me`, `am --> are`.

