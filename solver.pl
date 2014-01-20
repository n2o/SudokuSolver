%% --------------------------------------------------------
%% Competing in the Stups Challenge
%%
%% Solution by Christian Meter
%% 20th January 2014
%% --------------------------------------------------------

%% Initialize Sudoku and solve it!
solve_sudoku(InputFile, OutputFile) :-
	parse(Entry, InputFile), !,	
	length(Entry, L),

	sudoku(Entry, Solution),
	
	write_list_to_file(OutputFile, Solution).

%% --------------------------------------------------------
%% Parse Sudoku from file
%% --------------------------------------------------------

:- use_module(library(pio)).

parse(Entry, PathToFile) :-
	phrase_from_file(nats(Entry), PathToFile).

nats([]) --> [].

nats([_|Entry]) --> 
	wsp, "X", wsp,
	nats(Entry). 

nats([N|Entry]) -->
	wsp, nat(N), wsp,
	nats(Entry).

nats(Entry) --> 
	wsp, "|", wsp, 
	nats(Entry).

nats(Entry) --> 
	wsp, "-", wsp, 
	nats(Entry).

nats(Entry) --> 
	wsp, "+", wsp, 
	nats(Entry).

nats(Entry) --> 
	wsp, "\n", wsp,
	nats(Entry).

wsp  --> " "; "+"; "-"; ""; "  "; "   ".

digit(0) --> "0".
digit(1) --> "1".
digit(2) --> "2".
digit(3) --> "3".
digit(4) --> "4".
digit(5) --> "5".
digit(6) --> "6".
digit(7) --> "7".
digit(8) --> "8".
digit(9) --> "9".

nat(N)   --> digit(D), nat(D,N).
nat(A,N) --> digit(D), { A1 is A*10 + D }, nat(A1,N).
nat(N,N) --> [].


%% --------------------------------------------------------
%% Solve Sudoku
%% --------------------------------------------------------

:- use_module(library(clpfd)).

sudoku(Puzzle, Solution) :-
	length(Puzzle, L),
	Size is floor(sqrt(L)),

	Solution = Puzzle,
	Solution ins 1..Size,

	partition(Size, Solution, Rows),
	maplist(all_different, Rows),

	transpose(Rows, Cols),
	maplist(all_different, Cols),

	create_squares(Solution, Squares, Size, 0),
	maplist(all_different, Squares),

	labeling([ff,enum],Puzzle).

%% Need to simplify this!
%% Works as partition for Clojure: 
%% http://clojuredocs.org/clojure_core/clojure.core/partition

partition(Length,List,ListOfLists) :-
	partition(Length,Length,List,ListOfLists).
partition(Length,Offset,List,Lsg) :-
	partition_aux(Length,Offset,nil,List,[],Lsg).
partition_aux(Length,_,nil,List,Acc,RAcc) :-
	length(List,L), L < Length, !,
	reverse(Acc,RAcc).
partition_aux(Length,Offset,Buffer,List,Acc,Lsg) :-
	length(Temp,Length),
	append(Temp,_Rest,List),
	length(Temp2,Offset),
	append(Temp2,Rest2,List),
	partition_aux(Length,Offset,Buffer,Rest2,[Temp|Acc],Lsg).

create_squares(_, Square, Size, I) :- 
	I is Size * Size, 
	length(Square, Size), 
	sublist_length(Square, Size).

create_squares([H|T], Square, Size, I) :-
	square_pointer(Size, X, Y, I), 
	combine_to_squares(H, Square, X, Y),
	I1 is I + 1,
	create_squares(T, Square, Size, I1).

sublist_length([], _).
sublist_length([H|T], Length) :- 
	length(H, Length),
	sublist_length(T, Length).

combine_to_squares(Item, Values, X, Y) :-
	nth0(X, Values, Bucket),
	nth0(Y, Bucket, Item).

square_pointer(Size, X, Y, I) :- 
	Size_Sqrt is floor(sqrt(Size)),
	X is (I mod Size // Size_Sqrt) + (Size_Sqrt * (I // (Size * Size_Sqrt))),
	Y is (I mod Size_Sqrt) + (Size_Sqrt * ((I mod (Size * Size_Sqrt)) // Size)).

%% --------------------------------------------------------
%% Section to format to the Sudoku Solver Format 
%% --------------------------------------------------------

write_list_to_file(Filename, List) :-
	open(Filename, write, File),
	length(List, L),
	Size is floor(sqrt(sqrt(L))),
	write_to_file(File, List, Size, 1, 1),
	close(File).

write_to_file(_File, [], _, _, _) :- !.
write_to_file(File, List, Size, X, Y) :-
	Y mod (Size+1) =:= 0,
	Y1 is Y + 1,
	NumOfElements is Size * Size,
	
	write_spacing_line(File, Size, NumOfElements, 1),
	write(File, '\n'),

	write_to_file(File, List, Size, X, Y1), !.

write_to_file(File, [H|T], Size, X, Y) :-
	NeedABar  is X mod Size,
	EndOfLine is X mod (Size * Size),
	X1 is X + 1,
	Y1 is Y + 1,

	write(File, ' '), write(File, H), write(File, ' '),

	%% If Pos mod SquareSize = 0, then print '|'
	(NeedABar =:= 0, EndOfLine > 0
		-> write(File, '|')
		;  true),

	%% If X reaches the end of a line
	(EndOfLine =:= 0
		-> write(File, '\n'), write_to_file(File, T, Size, X1, Y1)
		;  write_to_file(File, T, Size, X1, Y)).

write_spacing_line(_, Size, Pos, Pos1) :-
	Pos1 is Pos + Size.
write_spacing_line(File, Size, NumOfElements, Pos) :-
	Pos1 is Pos + 1,
	
	(Pos mod (Size+1) =:= 0
		-> write(File, '+')
		;  write(File, '---')),

	write_spacing_line(File, Size, NumOfElements, Pos1).