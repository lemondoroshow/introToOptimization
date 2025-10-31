% Turn on diary
diary HW8prob8.txt

% Set up data
A = [1, 2, 3, 4;
     1, 6, 7, 2;
     1, 1, 9, 6;
     1, 4, 8, 3;
     1, 2, 6, 1;
     1, 7, 1, 3];
b = [5.14;
     8.41;
     7.98;
     7.91;
     5.01;
     6.91];

% Solve
min = inv(A' * A) * A' * b

% Turn off diary
diary off