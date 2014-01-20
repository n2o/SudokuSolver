# SudokuSolver in Prolog

This is a Sudoku Solver written in SWI-Prolog with the aim to solve the Sudoku very fast with a variable size.

## Input File

The source code can be found in [solver.pl](solver.pl). This solver reades a Sudoku from a file in the following format:

```
X X X | X X X | X X X 
X X 4 | 8 X X | X 1 7 
6 7 X | 9 X X | X X X 
------+-------+------- 
3 X X | 7 4 X | 1 X X 
X 6 9 | X X X | 7 8 X 
X X 1 | X 6 9 | X X 5 
------+-------+------- 
1 X X | X 8 X | 3 X 6 
X X X | X X 6 | X 9 1 
2 4 X | X X 1 | 5 X X
```
Some samples can be found in [sudoku.txt](sudoku.txt) - [sudoku6.txt](sudoku6.txt). The DCG Parser only reads 'X' as an empty position in the grid. 

The Solver accepts variable sizes of the Sudoku. It has been tested with 4x4, 9x9, 16x16 and 25x25 Sudokus.


## Output Files

The output file is again the same format as the input file, for example:

```
 5  1  8 | 6  3  7 | 9  2  4 
 9  3  4 | 8  2  5 | 6  1  7 
 6  7  2 | 9  1  4 | 8  5  3 
---------+---------+---------
 3  2  5 | 7  4  8 | 1  6  9 
 4  6  9 | 1  5  3 | 7  8  2 
 7  8  1 | 2  6  9 | 4  3  5 
---------+---------+---------
 1  9  7 | 5  8  2 | 3  4  6 
 8  5  3 | 4  7  6 | 2  9  1 
 2  4  6 | 3  9  1 | 5  7  8 

```


## How to use

The Solver can be used as follows:

```
> swipl -l solver.pl

?- solve_sudoku('sudoku.txt','sol.txt').
true .
```
