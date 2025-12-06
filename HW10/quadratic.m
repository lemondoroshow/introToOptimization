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
    
    % Compile vector
    xyz = [x; y; z];

    % Get epsilon value based on parity
    eps = mod(k, 2) * eps_min + abs(1 - mod(k, 2)) * eps_max;

    % Find avg complementarity
    beta = z' * x / n;

    % Find F of current vector subject to beta-epsilon
    F = [-Q * x - c + A' * y + z;
         A * x - b;
         (z .* x) - (ones(n, 1) * eps * beta)];

    % Find gradient of F
    % Transposed for consistency but it's a Jacobian so it's symmetric
    grad_F = [-Q, A', eye(n);
                A, zeros(m, m), zeros(m, n);
                diag(z), zeros(n, m), diag(x)]';
    
    % Find vector gradient 
    grad_xyz = -1 * grad_F \ F;

    % Find maximum z_i * x_i
    limit = delta * beta;

    
    break
end