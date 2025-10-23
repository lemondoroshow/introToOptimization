%% Boilerplate

% Turn on diary
diary HW7prob4.txt

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

% Define input board
M = [1 2 3 6 4 5 0 0 0;
     4 5 6 0 0 0 0 0 0;
     7 8 9 0 0 0 0 0 0;
     5 0 0 0 0 0 0 0 0;
     8 0 0 0 0 0 0 0 0;
     2 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0];

% Initialize b
b = ones(567, 1);

%% Find objective function (c)

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

%% Define constraint matrix (A)

% Set initial matrix
A = zeros(567, 729);
A_row = 0;

% Set 1-integer constraints
for i = 1:3
    for j = 1:3
        for k = 1:3
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

% Set i-l constraints
for i = 1:3
    for l = 1:3
        for m = 1:9

            % Increment row of A to operate on
            A_row = A_row + 1;

            % Summation
            for j = 1:3
                for k = 1:3

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end

% Set j-k constraints
for j = 1:3
    for k = 1:3
        for m = 1:9

            % Increment row of A to operate on
            A_row = A_row + 1;

            % Summation
            for i = 1:3
                for l = 1:3

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end

% Set k-l constraints
for k = 1:3
    for l = 1:3
        for m = 1:9

            % Increment row of A to operate on
            A_row = A_row + 1;

            % Summation
            for i = 1:3
                for j = 1:3

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end
%% Solve linear program

% Use intlinprog
x = intlinprog(c, (1:729)', [], [], A, b, zeros(729, 1), ones(729, 1));

% Decode x
x = round(x, 0);
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
        if M(R, C) ~= big_M(R, C) & ...
                M(R, C) ~= 0
            errors = errors + 1;
        end
    end
end

% Calculate error ratio
error_ratio = errors / total_entries;

% Display
disp('M')
disp(big_M)
disp('Error ratio')
disp(error_ratio)

% Turn off diary
diary off