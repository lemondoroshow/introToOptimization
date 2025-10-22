%% Boilerplace

function [position] = indexToPosition(i, j, k, l, m)

    % Convert x_ijklm to x_position
    position = (i - 1) * 3 ^ 5 + (j - 1) * 3 ^ 4 + ...
               (k - 1) * 3 ^ 3 + (l - 1) * 3 ^ 2 + ...
               (m - 1) + 1;
    
end

% Define input board
M = [8 0 0 0 0 0 0 0 0;
     0 0 3 6 0 0 0 0 0;
     0 7 0 0 9 0 2 0 0;
     0 5 0 0 0 7 0 0 0;
     0 0 0 0 4 5 7 0 0;
     0 0 0 1 0 0 0 3 0;
     0 0 1 0 0 0 0 6 8;
     0 0 8 5 0 0 0 1 0;
     0 9 0 0 0 0 4 0 0];

%% Find objective function (c)

% Initialize c
c = zeros(size(M, 1) * size(M, 2) * 9, 1);

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
                    c(pos) = 1;

                end
            end
        end
    end
end