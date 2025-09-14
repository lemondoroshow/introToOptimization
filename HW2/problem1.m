% Start diary
echo on
diary HW2prob1.txt

% Define objective function
c = [6.72 3.19 2.69 7.29 1.19]

% Define constraints
A = [-590 -170 -140 -310 -150;
     -46 -10 -18 -30 -39;
     -25 -9 -2 -17 0;
     34 10 8 13 0;
     85 25 0 250 0;
     1050 340 310 770 40]
b = [-2000; -275; -50; 78; 300; 2300]

% Solve linear program
x = linprog(c, A, b, [], [], zeros(5, 1), [])

% Solve optimal obj func
obj = c * x

% Define new objective function
c2 = [6.72 3.19 2.69 7.29 500]

% Solve new linear program & obj func
x2 = linprog(c2, A, b, [], [], zeros(5, 1), [])
obj2 = c2 * x2

% Attempt 1 to adjust b to reduce cost
b2 = [-1500; -275; -50; 78; 300; 2300]
x3 = linprog(c2, A, b2, [], [], zeros(5, 1), [])
obj3 = c2 * x3

% Attempt 2 to adjust b to reduce cost
b3 = [-1500; -150; -50; 78; 300; 2300]
x4 = linprog(c2, A, b3, [], [], zeros(5, 1), [])
obj4 = c2 * x4

% Attempt 3 to adjust b to reduce cost
b4 = [-1000; -150; -50; 78; 300; 2300]
x5 = linprog(c2, A, b4, [], [], zeros(5, 1), [])
obj5 = c2 * x5

% Attempt 4 to adjust b to reduce cost
b5 = [-1000; -150; -50; 78; 300; 3200]
x6 = linprog(c2, A, b5, [], [], zeros(5, 1), [])
obj5 = c2 * x6

% Attempt 5 to adjust b to reduce cost
b6 = [-1000; -150; -50; 95; 300; 3200]
x7 = linprog(c2, A, b6, [], [], zeros(5, 1), [])
obj5 = c2 * x7

% Close diary
diary off