% For my sake, turn off scientific notation
format shortG

% Import / set data
%{
load('prob1datafile.mat')
disp(A)
disp(b)
disp(c)
basis_selection = [1 2 3];
%}
A = [0.27 0.12 0.045 1 0 0 0; 
     1 0.75 0.2 0 1 0 0; 
     2 -1 0 0 0 1 0;
     0 0 1 0 0 0 1]
b = [100; 480; 0; 300]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]
basis_selection = [1 2 4 7]



% Split constraints
B = A(:, basis_selection);
N = A(:, setdiff(1:size(A, 2), basis_selection));

% Split obj func
c_b = c(basis_selection, :);
c_n = c(setdiff(1:size(A, 2), basis_selection),:);

% Get bottom-row tableau values
zero_col = zeros(size(basis_selection, 2), 1);
I = eye(size(basis_selection, 2));
invB_N = B \ N;
x_b = B \ b;

% Get top-row tableau values
zero_row = zeros(1, size(basis_selection, 2));
r_nT = -c_n' + c_b' * invB_N;
ofv = c_b' * x_b;

% Construct tableau
basic_tableau = [1, zero_row, r_nT, ofv;
                 zero_col, I, invB_N, x_b]

% Start loop until all reduced costs are positive
while any(r_nT > 0)
    
    % Find greatest reduced cost
    pivot_col = find(abs(basic_tableau(1, :) - max(r_nT)) < 0.0001);

    % Loop through pivot column rows to find lowest positive ratio
    last_col = size(basic_tableau, 2);
    pivot_ratios = [];
    for i = 2:size(basic_tableau, 1)
        
        % Ensure ratio is non-negative
        pivot_ratio = basic_tableau(i, last_col) / ...
                basic_tableau(i, pivot_col);
        if pivot_ratio ~= 0 && ...
                basic_tableau(i, last_col) > 0
            
            % Add to collection, check if its the lowest
            pivot_ratios = [pivot_ratios pivot_ratio];

            % If lowest positive ratio, set pivot_row to i
            if pivot_ratio == min(pivot_ratios)
                pivot_row = i;
            end
        end
    end

    % Use row operations to ensure pivot point == 1
    basic_tableau(pivot_row, :) = basic_tableau(pivot_row, :) ...
         .* 1 / basic_tableau(pivot_row, pivot_col);
    
    % Reduce rows
    for irow = 1:size(basic_tableau, 1)
        if (basic_tableau(irow, last_col) ~= 0 ... % Prevent stalling
            && irow ~= pivot_row) ... % Don't operate on pivot row
            || irow == 1 % Ensure top row is included, even if OFV == 0

            basic_tableau(irow, :) = basic_tableau(irow, :) ...
                - basic_tableau(irow, pivot_col) ...
                * basic_tableau(pivot_row, :);

        elseif basic_tableau(irow, last_col) ... % Account for weird edge-
                - basic_tableau(irow, pivot_col) ... % case
                * basic_tableau(pivot_row, last_col) > 0

            basic_tableau(irow, :) = basic_tableau(irow, :) ...
                - basic_tableau(irow, pivot_col) ...
                * basic_tableau(pivot_row, :);
        end
    end
    
    % Simplify and display tableau
    basic_tableau

    % Define new reduced costs
    r_nT = basic_tableau(1, 2:(last_col - 1));
    r_nT = r_nT(r_nT ~= 0);
end

% Loop through rows to find x-indices
var_row = [];
for irow = 2:size(basic_tableau, 1)
    for icol = 2:size(basic_tableau, 2)

        % Get matrix value
        val = basic_tableau(irow, icol);

        % Check that column has one 1, rest 0s
        ovic = basic_tableau(setdiff(1:size(basic_tableau, 1), irow), icol);
        if val == 1 && ... 
                all(ovic == 0)
                
            % Store which row the variable is in  
            var_row = [var_row; [icol - 1, irow]];
        end
    end
end

% Form x vector
% Still unsure if this is correct, but I don't know why it wouldn't be
x = zeros(size(A, 2), 1);
for var = 1:size(var_row, 1)
    
    % Set x at the position of the variable to the optimal vector value
    x(var_row(var, 1), :) = basic_tableau(var_row(var, 2), last_col);
end

% Isolate OFV
ofv = basic_tableau(1, last_col);

% Output optimal x, OFV
disp("Optimal x")
disp(x)
disp("Optimal OFV")
disp(ofv)