% For my sake, turn off scientific notation
format shortG

% Import / set data
A = [0.27 0.12 0.045 1 0 0 0; 
     1 0.75 0.2 0 1 0 0; 
     2 -1 0 0 0 1 0;
     0 0 1 0 0 0 1]
b = [100; 480; 0; 300]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]
basis_selection = [1 2 3 4]

% Split constraints
B = A(:, basis_selection)
N = A(:, setdiff(1:size(A, 2), basis_selection))

% Split obj func
c_b = c(basis_selection, :)
c_n = c(setdiff(1:size(A, 2), basis_selection),:)

% Get bottom-row tableau values
zero_col = zeros(size(basis_selection, 2), 1)
I = eye(size(basis_selection, 2))
invB_N = inv(B) * N
x_b = inv(B) * b

% Get top-row tableau values
zero_row = zeros(1, size(basis_selection, 2))
r_nT = -c_n' + c_b' * invB_N
ofv = c_b' * x_b

% Construct tableau
basic_tableau = [1, zero_row, r_nT, ofv;
                 zero_col, I, invB_N, x_b]
