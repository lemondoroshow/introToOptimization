%% Create pre-tableau

% For my sake, turn off scientific notation
format shortG

% Import / set data
load('prob2datafile.mat')
disp(A)
disp(b)
disp(c)
basis = 1:3;

% Arrange pre-tableau
pretableau = [1, -1*c', 0;
              zeros(size(A,1),1), A, b]

disp("Done")
%% Create initial tableau

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

tableau = pretableau

disp("Done")
%% Find initial reduced costs

neg_r_nT = [];
neg_r_nT_i = [];
for ind = 2:size(tableau, 2) - 1
    col = tableau(:, ind);

    % Check if column is standard basis
    if ~any(abs(col(col ~= 0) - 1) > 0) && ...
            sum(col ~= 0) == 1

        % Do nothing

    else 
        neg_r_nT = [neg_r_nT; tableau(1, ind)];
        neg_r_nT_i = [neg_r_nT_i; ind];
    end
end

% Create "dictionary" for reduced costs
neg_r_nT_i = [neg_r_nT neg_r_nT_i];

disp("Done")
%% Loop through simplex method

% Iterate while any reduced costs are non-negative
loop_no = 1
while any(neg_r_nT >= 0)

    % Find greatest reduced cost
    [~, pos] = max(neg_r_nT_i);
    pivot_col = neg_r_nT_i(pos(1), 2);
    
    % Find lowest positive ratio
    last_col = size(tableau, 2);
    pivot_ratios = [];
    for i = 2:size(tableau, 1)
        
        % Ensure each part is non-negative
        pivot_ratio = tableau(i, last_col) / ...
                tableau(i, pivot_col);
        if tableau(i, last_col) >= 0 && ...
                tableau(i, pivot_col) >= 0
            
            % Add to collection, check if its the lowest
            pivot_ratios = [pivot_ratios pivot_ratio];

            % If lowest positive ratio, set pivot_row to i
            if pivot_ratio == min(pivot_ratios)
                pivot_row = i;
            end
        end
    end
    
    if all(pivot_ratio < 0)
        disp("Program is unbounded")
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
    disp(tableau)
    
    % Find next reduced costs
    neg_r_nT = [];
    neg_r_nT_i = [];
    for ind = 2:size(tableau, 2) - 1
        col = tableau(:, ind);

        % Check if column is standard basis
        if ~any(abs(col(col ~= 0) - 1) > 0) && ...
               sum(col ~= 0) == 1

            % Do nothing

        else 
            neg_r_nT = [neg_r_nT; tableau(1, ind)];
            neg_r_nT_i = [neg_r_nT_i; ind];
        end
    end
    
    % Create "dictionary" for reduced costs
    neg_r_nT_i = [neg_r_nT neg_r_nT_i];
    loop_no = loop_no + 1
end

%%