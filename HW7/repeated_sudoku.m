% Turn on diary
diary HW7prob2.txt

function [position] = indexToPosition(i, j, k, l, m)

    % Convert x_ijklm to x_position
    position = (i - 1) * 3 ^ 5 + (j - 1) * 3 ^ 4 + ...
               (k - 1) * 3 ^ 3 + (l - 1) * 3 ^ 2 + ...
               (m - 1) + 1;
    
end

function [i, j, k, l, m] = positionToIndex(position)
    
    % Find i
    rem = int16(position - 1);
    i = idivide(rem, 3 ^ 5) + 1;
    rem = rem - (i - 1) * 3 ^ 5;

    % Find j
    j = idivide(rem, 3 ^ 4) + 1;
    rem = rem - (j - 1) * 3 ^ 4;

    % Find k
    k = idivide(rem, 3 ^ 3) + 1;
    rem = rem - (k - 1) * 3 ^ 3;

    % Find l
    l = idivide(rem, 3 ^ 2) + 1;
    rem = rem - (l - 1) * 3 ^ 2;

    % Find m
    m = rem + 1;

end

% Loop 1000 times
ratios = [];
for loop_no = 1:1000

    % Define input board
    M = ceil(9 * rand(9, 9));
    
    % Initialize b
    b = ones(324, 1);
    
    % Initialize c
    c = ones(729, 1);
    
    % Loop through M to find values for c
    for i = 1:3
        for j = 1:3
            for k = 1:3
                for l = 1:3
    
                    % Get entry
                    row_index = (i - 1) * 3 + k;
                    col_index = (j - 1) * 3 + l;
                    entry = M(row_index, col_index);
    
                    % Check if entry is non-zero
                    if entry ~= 0
    
                        % Add 1 to c in position
                        m = entry;
                        pos = indexToPosition(i, j, k, l, m);
                        c(pos) = 0;
    
                    end
                end
            end
        end
    end
    
    % Set initial matrix
    A = zeros(324, 729);
    A_row = 0;
    
    % Set 1-integer constraints
    for i = 1:3
        for k = 1:3
            for j = 1:3
                for l = 1:3
                    
                    % Increment row of A to operate on
                    A_row = A_row + 1;
                    
                    % Summation
                    for m = 1:9
    
                        % Set A equal to 1 in correct positions
                        A(A_row, indexToPosition(i, j, k, l, m)) = 1;
    
                    end
                end
            end
        end
    end
    
    % Set large-square constraints
    for i = 1:3
        for j = 1:3
            for m = 1:9
    
                % Increment row of A to operate on
                A_row = A_row + 1;
    
                % Summation
                for k = 1:3
                    for l = 1:3
    
                        % Set A equal to 1 in correct positions
                        A(A_row, indexToPosition(i, j, k, l, m)) = 1;
    
                    end
                end
            end
        end
    end
    
    % Set row constraints
    for i = 1:3
        for k = 1:3
            for m = 1:9
    
                % Increment row of A to operate on
                A_row = A_row + 1;
    
                % Summation
                for j = 1:3
                    for l = 1:3
    
                        % Set A equal to 1 in correct positions
                        A(A_row, indexToPosition(i, j, k, l, m)) = 1;
    
                    end
                end
            end
        end
    end
    
    % Set column constraints
    for j = 1:3
        for l = 1:3
            for m = 1:9
    
                % Increment row of A to operate on
                A_row = A_row + 1;
    
                % Summation
                for i = 1:3
                    for k = 1:3
    
                        % Set A equal to 1 in correct positions
                        A(A_row, indexToPosition(i, j, k, l, m)) = 1;
    
                    end
                end
            end
        end
    end
    
    % Use intlinprog
    opt = optimoptions("intlinprog", display = "off");
    x = intlinprog(c, (1:729)', [], [], A, b, zeros(729, 1), ones(729, 1), ...
                   [], opt);
    
    % Decode x
    big_M = zeros(size(M, 1), size(M, 2));
    for ind = 1:size(x, 1)
        
        % Ensure x is one
        if x(ind, :) == 1
        
            % Get coordinates
            [i, j, k, l, m] = positionToIndex(ind);
        
            % Get row and column index
            row_index = (i - 1) * 3 + k;
            col_index = (j - 1) * 3 + l;
        
            % Set entry of M equal to m
            big_M(row_index, col_index) = m;
    
        end
    end
    
    % Find error ratio
    total_entries = 0;
    errors = 0;
    for R = 1:size(M, 1)
        for C = 1:size(M, 2)
            
            % Increment entries
            total_entries = total_entries + 1;
    
            % Add error if necessary
            if M(R, C) ~= big_M(R, C) && ...
                    M(R, C) ~= 0
                errors = errors + 1;
            end
        end
    end
    
    % Calculate error ratio
    error_ratio = errors / total_entries;
    ratios = [ratios; error_ratio];

end

% Display stats
disp("Mean")
disp(mean(ratios))
disp("Standard deviation")
disp(std(ratios))

% Turn off diary
diary off