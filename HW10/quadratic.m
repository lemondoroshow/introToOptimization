% Turn off scientific notation
format shortG

% Define data
Q = [4 1 1 1;
     1 5 2 1;
     1 2 6 2;
     1 1 2 7];
c = [2; -3; 1; -4];
A = [1 0 -2 1;
     0 -2 1 -3];
b = [-1; 2];

function [x, y, z, k] = quadraticProg(Q, c, A, b)

    % Get sizes
    n = size(Q, 1);
    m = size(b, 1);

    % Initialize values of x, y, z, delta, epsilons
    % These are basically entirely test values or given
    eps_min = 0.1;
    eps_max = 0.9;
    delta = 0.5;
    x = ones(n, 1);
    y = ones(m, 1);
    z = ones(n, 1);
    
    % Iterate until done
    finished = false;
    k = 1;
    while ~finished
        
        % Get epsilon value
        eps = mod(k, 2) * eps_min + abs(1 - mod(k, 2)) * eps_max;

        % Find avg complementarity
        beta = z' * x / n;
        
    end
end


