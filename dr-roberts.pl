%% Calls to answer the question and print the reply
printReply(Question) :-
	answer(Question, Answer),		% Call to answer the question
	reply(Answer).			% Print the reply

%% Answers the question
answer(Question, Answer) :-
	match(Question, Keyword),		% Find a matching keyword
	keyword(Keyword, Prefix),		% Match the keyword to prefix
	transform(Question, Response),		% Transform the question
	append(Prefix, Response, Answer).	% Append transformation to prefix

%% When no keyword was found in the question
answer(_, Answer) :-	% Fallback question to invoke response
	X is random(3),
	fallback(X, Answer).

fallback(0, [how, does, that, make, you, feel]).
fallback(1, [can, you, elaborate, on, that]).
fallback(2, [what, else, is, on, your, mind]).

%% Finds a keyword match in the question
match([], _) :- fail.							% No keyword match
match([Word|_], Word):- keyword(Word, _).	% Check if current word is a keyword match
match([_|Rest], Result):- match(Rest, Result).	% Current word did not succeed, check the rest

%% Transforms the perspective of the question
transform([], []).
transform([Word|Rest], [Replacement|Result]) :-	% List of words, prepend replacement to result
	replace(Word, Replacement),				% Replace the word with its transformation
	transform(Rest, Result).					% Transform the rest of the list

%% Prints the reply, question mark, and new line.
reply(Reply) :-
	printSentence(Reply),	% Print the response sentence
	write('?'), nl.		% Follow with question mark and new line

printSentence([]).		% No words left, done
printSentence([W|[]]) :-	% Last word
	write(W).		% Print the last word

printSentence([W|R]) :-		% Not the last word
	write(W),		% Print word
	write(' '),		% Print space
	printSentence(R).	% Print the rest recursively

%% Replacement key-value pairs
replace(my, your).
replace(your, my).
replace(i, you).
replace(you, i).
replace(me, you).
replace(you, me).
replace(makes, make).
replace(am, are).
replace(myself, yourself).

%% No replacement was found, word stays the same
replace(Word, Word).

%% Keyword key-value pairs with respective prefixes
keyword(feel, [what, makes]).
keyword(have, [are, you, sure]).
keyword(know, [are, you, sure]).
keyword(need, [why, do]).
keyword(like, [why, do]).
keyword(love, [why, do]).
keyword(hate, [why, do]).
