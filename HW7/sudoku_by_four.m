%% Boilerplate

% Turn on diary
diary HW7prob3trial2.txt

function [position] = indexToPosition(i, j, k, l, m)

    % Convert x_ijklm to x_position
    position = (i - 1) * 4 ^ 5 + (j - 1) * 4 ^ 4 + ...
               (k - 1) * 4 ^ 3 + (l - 1) * 4 ^ 2 + ...
               (m - 1) + 1;
    
end

function [i, j, k, l, m] = positionToIndex(position)
    
    % Find i
    rem = int16(position - 1);
    i = idivide(rem, 4 ^ 5) + 1;
    rem = rem - (i - 1) * 4 ^ 5;

    % Find j
    j = idivide(rem, 4 ^ 4) + 1;
    rem = rem - (j - 1) * 4 ^ 4;

    % Find k
    k = idivide(rem, 4 ^ 3) + 1;
    rem = rem - (k - 1) * 4 ^ 3;

    % Find l
    l = idivide(rem, 4 ^ 2) + 1;
    rem = rem - (l - 1) * 4 ^ 2;

    % Find m
    m = rem + 1;

end

% Define input board
% M = zeros(16, 16); % Trial 1
M = [5	11	1	4	12	8	15	16	6	3	10	9	13	2	14	7;
    14	9	15	16	3	10	2	7	11	12	5	13	4	1	6	8;
    10	6	8	2	11	13	14	5	16	7	4	1	3	12	9	15;
    13	3	7	12	9	6	4	1	15	2	14	8	11	16	10	5;
    12	2	6	5	10	7	13	14	3	16	15	11	9	8	4	1;
    9	1	11	7	8	16	6	3	5	14	13	4	10	15	2	12;
    3	4	10	13	1	9	11	15	2	8	7	12	6	5	16	14;
    8	16	14	15	4	2	5	12	9	10	1	6	7	13	3	11;
    6	8	9	1	2	11	7	10	4	15	12	3	5	14	13	16;
    7	12	13	11	16	15	9	4	10	5	8	14	2	6	1	3;
    2	10	5	14	13	3	12	6	1	9	11	16	15	7	8	4;
    16	15	4	3	14	5	1	8	13	6	2	7	12	10	11	9;
    11	7	2	10	5	4	8	13	14	1	9	15	16	3	12	6;
    1	13	12	9	6	14	3	2	7	4	16	5	8	11	15	10;
    4	5	3	8	15	1	16	11	12	13	6	10	14	9	7	2;
    15	14	16	6	7	12	10	9	8	11	3	2	1	4	5	14];
    % Trial 2 - last entry changed from 13 to 14

% Initialize b
b = ones(1024, 1);

%% Find objective function (c)

% Initialize c
c = ones(4096, 1);

% Loop through M to find values for c
for i = 1:4
    for j = 1:4
        for k = 1:4
            for l = 1:4

                % Get entry
                row_index = (i - 1) * 4 + k;
                col_index = (j - 1) * 4 + l;
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
A = zeros(1024, 4096);
A_row = 0;

% Set 1-integer constraints
for i = 1:4
    for k = 1:4
        for j = 1:4
            for l = 1:4
                
                % Increment row of A to operate on
                A_row = A_row + 1;
                
                % Summation
                for m = 1:16

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end

% Set large-square constraints
for i = 1:4
    for j = 1:4
        for m = 1:16

            % Increment row of A to operate on
            A_row = A_row + 1;

            % Summation
            for k = 1:4
                for l = 1:4

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end

% Set row constraints
for i = 1:4
    for k = 1:4
        for m = 1:16

            % Increment row of A to operate on
            A_row = A_row + 1;

            % Summation
            for j = 1:4
                for l = 1:4

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end

% Set column constraints
for j = 1:4
    for l = 1:4
        for m = 1:16

            % Increment row of A to operate on
            A_row = A_row + 1;

            % Summation
            for i = 1:4
                for k = 1:4

                    % Set A equal to 1 in correct positions
                    A(A_row, indexToPosition(i, j, k, l, m)) = 1;

                end
            end
        end
    end
end

%% Solve linear program

% Use intlinprog
x = intlinprog(c, (1:4096)', [], [], A, b, zeros(4096, 1), ones(4096, 1));

% Decode x
x = round(x, 0);
big_M = zeros(size(M, 1), size(M, 2));
for ind = 1:size(x, 1)
    
    % Ensure x is one
    if x(ind, :) == 1
    
        % Get coordinates
        [i, j, k, l, m] = positionToIndex(ind);
    
        % Get row and column index
        row_index = (i - 1) * 4 + k;
        col_index = (j - 1) * 4 + l;
    
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

% Display
disp('M')
disp(big_M)
disp('Error ratio')
disp(error_ratio)

% Turn off diary
diary off