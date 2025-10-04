% For my sake, turn off scientific notation
format shortG

% Import / set data
A = [];
b = [];
c = [];
basis_selection = [];

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
loop_no = 1;
while any(r_nT > 0)
    
    % Find greatest reduced cost
    [temp_row, pivot_col] = find(basic_tableau == max(r_nT));

    % Loop through pivot column rows to find lowest positive ratio
    last_col = size(basic_tableau, 2);
    pivot_ratios = [];
    for i = 2:size(basic_tableau, 1)
        
        % Ensure ratio is non-negative
        % WARNING: MAY STALL
        pivot_ratio = basic_tableau(i, last_col) / ...
                basic_tableau(i, pivot_col);
        if pivot_ratio >= 0
            
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
    for irow = setdiff(1:size(basic_tableau, 1), pivot_row)
        basic_tableau(irow, :) = basic_tableau(irow, :) ...
            - basic_tableau(irow, pivot_col) ...
            * basic_tableau(pivot_row, :);
    end

    % Define new reduced costs
    r_nT = basic_tableau(1, 2:(last_col - 1));
    r_nT = r_nT(r_nT ~= 0);
    
end
