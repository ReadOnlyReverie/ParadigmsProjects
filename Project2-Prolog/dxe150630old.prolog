% Author: Daniel Easley
% Date Due: 11/28/2022
% Class: CS 4337.002 (UTD)
% Purpose: Define and test various prolog predicates as instructed in the project assignment.

% 1. Second Minimum:

% Purpose: Find the second minimum in a list of numbers.
%		   Give an error if the list has less than 2 unique elements
%		   or if it is not all numbers.

% Wrapper predicate to call all helpers:
secondMin(List, M2) :-
    allNumbers(List), unique2(List), findSecondMin(List, M2).

% Checks if all elements of the list are numbers:
allNumbers([]).

allNumbers([H|T]):-
    % Stop searching if head is a number.
    number(H),!,
    
    % Recursive call to check all elements
    allNumbers(T),!.

allNumbers([H|_]):-
    % Reach this predicate if head is not a number, print error
    write("ERROR: "),write(H),writeln(" is not a number."),false,!.


% Check that at least 2 of the elements of the list are unique:
unique2([_]) :-
    % Start here if list only has one element, print error
    writeln("ERROR: List has fewer than two unique elements."),false,!.

unique2([H|T]) :-
    % Otherwise, start here, split list into head and tail 
    % to pass to next predicate
	unique2(H, T).
    
unique2(H, [H|T]) :-
    % Keep recursing down until H (first head) 
    % is not equal to H (second head), or until tail list is empty
    unique2(H,T),!.

unique2(H1, [H2|_]) :-
    % Check if H1 is not equal to H2, stop searching if true
    not(H1=H2),!.

unique2(A, [A]) :-
    % If recursion has reached a point where the list is only left with one
    % element that is equal to the head, then print error
    writeln("ERROR: List has fewer than two unique elements."),false,!.


% Main driver predicate to find second min:
findSecondMin(List, M2) :-
    min_list(List, M1), 
    delete(List, M1, List1), 
    min_list(List1, M2).



% 2. Classify:

% Purpose: Classify a list of numbers into two lists,
%          one containing even numbers, and the other containing odd.

classify(List, Even, Odd) :-
    findClassification(List, Even, Odd).

% Base case:
findClassification([],[],[]).

%Classify the even numbers:
findClassification([H|T1], [H|T2], Odd) :-
    0 is H mod 2, !,
    classify(T1, T2, Odd).

% If not classified as even, then it must be odd.
% Therefore, classify as odd:
findClassification([H|T1], Even, [H|T2]) :-
    classify(T1, Even, T2).



% 3. Subslice:

% Purpose: Determine if List1 is a subslice of List2.

subslice(List1, List2) :-
    findSubslice(List1, List2).

% Base case:
findSubslice([], _).

% Recursively cut off the head of a list until the prefix
% function returns true, else return false.
findSubslice(Contiguous, [H|T]) :-
    prefix(Contiguous, [H|T]), !;
    findSubslice(Contiguous, T).



% 4. Shift:

% Purpose: Shift a list N places to the left when N is positive,
%		   or N places to the right when N is negative. Shifts
%		   should wrap-around as opposed to falling off.

shift(OriginalList, ShiftAmount, ShiftedList) :-
    doShift(OriginalList, ShiftAmount, ShiftedList).

% Base case:
doShift(L, N, L) :- 
    N = 0,
    !.

% When N is positive:
doShift(L1, N, L2) :-
  N > 0, 
  shiftLeft(L1, L),
  N1 is N-1,			% Decrement N
  doShift(L, N1, L2).	% Recursive call

% When N is negative:
doShift(L1, N, L2) :-
  N < 0, 
  shiftRight(L1, L), 
  N1 is N+1,			% Increment N
  doShift(L, N1, L2).	% Recursive call

% For shifting positive N:
shiftLeft([H|T], L) :- append(T, [H], L).

% For shifting negative N:
shiftRight(L, [H|T]) :- append(T, [H], L).



% 5. Luhn Algorithm:

% Purpose: Implement the Luhn algorithm. Return true if the integer given 
% 		   passes the Luhn test, return false otherwise.
    
luhn(Integer) :-
    reversedNumToList(Integer, RevList), 	% Reverse the number and index the digits in an array.
    addEveryOther(RevList, S1),				% Add the odd indices and store the result in S1.
    skipThis2(RevList, S2),					% Skip the first index to start on an even index.
    checkResult(S1, S2), !.					% Check if (S1+S2) mod 10 = 0.
    
% Append digits to a list in reverse
reversedNumToList(NUM, [LIST|[]]) :-
    NUM < 10,
    LIST is NUM,
    !.
reversedNumToList(NUM,LIST) :-
    P is NUM // 10,
    reversedNumToList(P, LIST1),
    END is (NUM mod 10),
    append([END],LIST1, LIST).

% Add every other digit (used for the odd indices):
addEveryOther([], 0) :- !.
addEveryOther([H|T], S) :-
    skipThis1(T, S1),
    S is H + S1.

% Skip the even indices:
skipThis1([], 0) :- !.
skipThis1([_|T], S) :- addEveryOther(T, S).

% Skip the odd indices:
skipThis2([], 0) :- !.
skipThis2([_|T], S) :- doubleAndAddDigits(T, S).

% Doubles the even indices and adds the digits of the doubled numbers
doubleAndAddDigits([], 0) :- !.
doubleAndAddDigits([H|T], S) :-
    skipThis2(T, S1),
    DoubleH is H*2,
    sumofdigits(DoubleH, SumOfDigitsOfDoubles),
    S is SumOfDigitsOfDoubles + S1.

% Helper method to add the individual digits of a number:
sumofdigits(X, X) :- 
    X<10.
sumofdigits(X, Y) :- 
    X>=10, 
    X1 is X // 10,
    X2 is X mod 10, 
    sumofdigits(X1, Y1), 
    Y is Y1 + X2.

% Add S1 and S2, check if the result mod 10 = 0:
checkResult(X, Y) :-
    TotalSum is X+Y,
    FinalResult is TotalSum mod 10,
    FinalResult = 0.



% 6. Graph:

% Purpose: Design two predicates path/2 and cycle/1 that determine structures 
% 		   within a graph whos directed edges are encoded with given instances of edge/2.

% Example knowledge base:
/*edge(a,b).
edge(b,c).
edge(c,d).
edge(d,a).
edge(d,e).
edge(b,a).*/

% Base case, checks for a direct edge:
path(X, Y) :-
    edge(X, Y),
    !.

% See if there is a path from X to Y:
path(X, Y) :-
    edge(X, A),		% Find a node A that is adjacent to X
    
    % Recursive call tries to build a path from
    % X to Y by continually finding adjcant nodes:
    path(A, Y),
    !.

% See if there is a cycle from X back to itself.
cycle(X) :-
    
    % Simply call the path predicate with the same source and destination:
    path(X, X),
    !.



% 7. Clue:

% Purpose: simulate a game of clue in prolog.

:- discontiguous(rich/1).

% Knowledge base from given clues:

affairWith(X, Y) :-
    affair(X, Y),!.
affairWith(X, Y) :-
    affair(Y, X),!.

affair(mrBoddy, msGreen).
affair(missScarlet, mrBoddy).
          
marriedTo(X, Y) :-
    married(X, Y),!.
marriedTo(Y, X) :-
    married(Y, X),!.

married(profPlum, msGreen). married(msGreen, profPlum).
          
rich(mrBoddy).
          
greedy(colMustard).

% ***Extra clue added to create only one suspect:***
rich(colMustard).

hatred(Person1, Person2) :- % Person1 hates Person2 for affair with Person3
    affairWith(Person2, Person3),
    marriedTo(Person1, Person3).

greed(Person1, Person2) :- % Person1 is greedy and not rich, Person2 is rich
    rich(Person2),
    greedy(Person1),
    not(rich(Person1)).

suspect(Killer, Victim) :-
    hatred(Killer, Victim) ; greed(Killer, Victim).



% 8. Zebra Puzzle:

% Purpose: The five biggest DJs in the world are going to play in an 
% 		   electronic music festival, each one in a specific stage. 
% 		   They are side by side waiting to play. Given a set of properties
% 		   and clues (in the project assignment document)Find out their 
% 		   nationalities hobbies and which genre they play.

/*dj(Shirt_Color, Nationality, Music_Genre, Stage, Age, Hobby).

select([A|As],S):- 
    select(A,S,S1),
    select(As,S1).
select([],_).

directlyNext(A, B, Ls) :- append(_, [A,B|_], Ls).
directlyNext(A, B, Ls) :- append(_, [B,A|_], Ls).

directlyAdjacent(A,B,List) :- directlyNext(A,B,List) ; directlyNext(B,A,List).

somewhereNext(A, B, Ls) :-.
somewhereNext(A, B, Ls) :-.

somewhereAdjacent(A, b, List) :- somewhereNext(A, B, Ls) ; somewhereNext(B, A, Ls).

between(A, B, C, Ls) :- .
somewhereBetween(A, B, C, Ls) :- .

dj(DJ) :- %shirt color, nationality, music genre, stage, age, hobby
    length(DJ, 5),
    
    %1. The Scott is somewhere to the left of the DJ wearing the White shirt.
    somewhereAdjacent(dj(_,scott,_,_,_,_), dj(white,_,_,_,_,_), DJ),
    %2. At the fourth position is the DJ who is going to play on the Arcadia stage.
    DJ = [_,_,_,dj(_,_,_,arcadia,_,_),_],
    %3. The 30-year-old DJ is at the first position.
	DJ = [dj(_,_,_,_,30,_),_,_,_,_],
    %4. The DJ that plays EDM is exactly to the right of the Canadian.
    directlyAdjacent(dj(_,_,edm,_,_,_), dj(_,canadian,_,_,_,_), DJ),
    %5. The one who likes Painting is next to the DJ who plays Dubstep.
    directlyAdjacent(dj(_,_,_,_,_,painting), dj(_,_,dubstep,_,_,_), DJ),
    %6. The DJ wearing the Black shirt is somewhere between the Scott and the Dubstep player, in that order
    somewhereBetween(dj(_,scott,_,_,_,_), dj(black,_,_,_,_,_), dj(_,_,dubstep,_,_,_), DJ),
    %7. The French DJ is next to the one wearing the Blue shirt.
    directlyAdjacent(dj(_,french,_,_,_,_), dj(blue,_,_,_,_,_), DJ),
    %8. At one of the ends is the DJ that likes Camping.
    DJ = [_,_,_,_,dj(_,_,_,_,_,camping)],
    %9. The DJ who is going to play on the Asgard stage is wearing the Blue shirt.
    select(dj(blue,_,_,_asgard,_,_), DJ),
    %10. The one that likes Painting is somewhere between the DJ wearing Green and the DJ wearing Blue, in that order.
    somewhereBetween(dj(green,_,_,_,_,_), dj(_,_,_,_,_,painting), dj(blue,_,_,_,_,_), DJ),
    %11. At the fifth position is the DJ who plays Drum and bass.
    DJ = [_,_,_,_,dj(_,_,drum_and_bass,_,_,_)],
    %12. In the middle is the DJ who is going to play on the Asgard stage.
    DJ = [_,_,dj(_,_,_,asgard,_,_),_,_],
    %13. The one who plays Trance is next to the one who plays Dubstep.
    directlyAdjacent(dj(_,_,trance,_,_,_), dj(_,_,dubstep,_,_,_), DJ),
    %14. The Canadian is exactly to the left of the DJ who likes Juggling.
    directlyAdjacent(dj(_,canadian,_,_,_,_), dj(_,_,_,_,_,juggling), DJ),
    %15. The DJ whose hobby is Singing is exactly to the right of the DJ wearing the Black shirt
    directlyAdjacent(dj(_,_,_,_,_,singing), dj(black,_,_,_,_,_), DJ),
    %16. The DJ in his Mid-thirties is next to the DJ who is into Juggling.
    directlyAdjacent(dj(_,_,_,_,35,_), dj(_,_,_,_,_,juggling), DJ),
    %17. The 40-year-old DJ is at the fourth position.
    DJ = [_,_,_,dj(_,_,_,_,40,_),_],
    %18. The 40-year-old DJ is somewhere between the Dutch and the youngest DJ, in that order.
    somewhereBetween(dj(_,dutch,_,_,_,_), dj(_,_,_,_,40,_), dj(_,_,_,_,25,_), DJ),
    %19. The DJ wearing Blue is somewhere to the left of the DJ who is going to play on the Xibalba stage.
    somewhereAdjacent(dj(blue,_,_,_,_,_), dj(_,_,_,xibalba,_,_), DJ),
    %20. The one who enjoys Surfing is going to play on the Valhalla stage.
    select(dj(_,_,_,valhalla,_,surfing), DJ),
    %21. The DJ wearing the Red shirt is somewhere to the right of the French.
    somewhereAdjacent(dj(red,_,_,_,_,_), dj(_,french,_,_,_,_), DJ).*/