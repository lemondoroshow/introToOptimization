% Turn off scientific notation
format shortG

function [x, ofv, y] = dualMethod(A, b, c, basis, show)

    % Create pretableau
    
    % Arrange pre-tableau
    pretableau = [1, -1*c', 0;
        zeros(size(A,1),1), A, b];
    if show
        disp(pretableau)
    end
    
    disp("Pre-tableau complete")
    
    %Create initial tableau
    
    % Iterate through selected basis
    k = 2;
    for i = basis
    
        % Make basic variable in first row 1
        irow = pretableau(k, :);
        pretableau(k, :) = 1 / irow(1, i + 1) * irow;
    
        % Subtract row from other rows
        for j = 1:size(pretableau, 1)
            if j ~= k
    
                % Row operations
                pretableau(j, :) = pretableau(j, :) ...
                    - pretableau(j, i + 1) / irow(1, i + 1) * irow;
            end
        end
    
        % Increment k
        k = k + 1;
    end
    
    
    tableau = pretableau;

    % Deal with super small values that should be zero
        tableau(abs(tableau) < 0.0001) = 0;

    if show
        disp(tableau)
    end
    
    disp("Initial tableau complete")
    
    % Get initial x_b vector
    
    % Find initial x_b
    x_b = [];
    x_b_i = [];
    for i = 2:size(tableau, 1)
        
        % Add entry to x_b
        x_b = [x_b; tableau(i, size(tableau, 2))];
        x_b_i = [x_b_i; i];
    
    end
    
    % Create "dictionary" for x_b components
    x_b_i = [x_b x_b_i];
    
    disp("x_b complete")
    
    % Loop through simplex method
    
    % Iterate while any x_b components are negative
    loop_no = 0
    while any(x_b < 0)
    
        % Find lowest x_b component
        [~, pos] = min(x_b_i);
        pivot_row = x_b_i(pos(1), 2);
    
        % Find lowest positive ratio
        pivot_ratios = [];
        fails = [];
        for i = 2:size(tableau, 2) - 1
    
            % Ensure each part is non-positive or negative
            % if (tableau(1, i) < -0.0001 || ... % Less than ...
                    % abs(tableau(1, i)) < 0.0001) && ... % ... or equal to
            if tableau(1, i) <= 0 && ...
                    tableau(pivot_row, i) < -0.0001 % Strictly less than
                fails = [fails; 0];
    
                % Add to collection
                pivot_ratio = tableau(1, i) / ...
                    tableau(pivot_row, i);
                pivot_ratios = [pivot_ratios pivot_ratio];
    
                % If lowest ratio, set pivot_col to i
                if pivot_ratio == min(pivot_ratios)
                    pivot_col = i;
                end
            else
                fails = [fails; 1];
            end
        end
    
        % Check for unboundedness
        if all(fails == 1)
            disp("Program is unbounded")
            finished = false;
            x = NaN(1, 1);
            ofv = NaN(1, 1);
            break
        end
    
        % Use row operations to ensure pivot point == 1
        tableau(pivot_row, :) = tableau(pivot_row, :) ...
            .* 1 / tableau(pivot_row, pivot_col);
    
        % Reduce rows
        for irow = 1:size(tableau, 1)
            if irow ~= pivot_row % Don't operate on pivot row
    
                % Row operations
                tableau(irow, :) = tableau(irow, :) ...
                    - tableau(irow, pivot_col) ...
                    * tableau(pivot_row, :);
            end
        end
    
        % Dispay tableau
        if show
            disp(tableau)
        end
    
        % Deal with super small values that should be zero
        tableau(abs(tableau) < 0.0001) = 0;
    
        % Show OFV
        if ~show
            disp(tableau(1, size(tableau, 2)))
            disp(min(pivot_ratios))
        end
    
        % Find next x_b
        x_b = [];
        x_b_i = [];
        for i = 2:size(tableau, 1)
            
            % Add entry to x_b
            x_b = [x_b; tableau(i, size(tableau, 2))];
            x_b_i = [x_b_i; i];
        
        end
        
        % Create "dictionary" for x_b
        x_b_i = [x_b x_b_i];

        % Increment
        loop_no = loop_no + 1
        finished = true;
    
    end
    
    disp("Simplex calculations complete")
    
    % Calculate optimal x, OFV
    
    last_col = size(tableau, 2);
    if finished
    
        % Loop through rows to find x-indices
        var_row = [];
        for irow = 2:size(tableau, 1)
            for icol = 2:size(tableau, 2)
    
                % Get matrix value
                val = tableau(irow, icol);
    
                % Check that column has one 1, rest 0s
                ovic = tableau(setdiff(1:size(tableau, 1), irow), icol);
                if val == 1 && ...
                        all(ovic == 0)
    
                    % Store which row the variable is in
                    var_row = [var_row; [icol - 1, irow]];
                end
            end
        end
    
        % Form x vector
        x = zeros(size(A, 2), 1);
        for var = 1:size(var_row, 1)
    
            % Set x at the position to the optimal vector value
            x(var_row(var, 1), :) = tableau(var_row(var, 2), last_col);
        end
    
        % Isolate OFV
        ofv = tableau(1, last_col);
        
        % Find y
        basis = sort(var_row(:, 1));
        c_b = c(basis, :);
        B = A(:, basis);
        y = c_b' / B;
    end
end

% Turn on diary
% diary HW6prob4.txt

% Load data
load("prob4datafile.mat")
basis = 6:11;
show = true;

% Run dual method
[x, ofv, y] = dualMethod(A, b, c, basis, show);

% Show results
disp("OFV: ")
disp(ofv)
disp("x: ")
disp(x)
disp("y: ")
disp(y')
disp('cTx = yTb')
c' * x
y * b

% Turn diary off
% diary off