% Turn off scientific notation
format shortG

% Turn on diary
diary HW10prob2a.txt

% Define data
Q = zeros(7, 7);
c = [-1.8; -1.4; -1.2; -1; 0; 0; 0];
A = [0 0 6 10 1 0 0;
     0 12 8 6 0 1 0;
     16 4 2 0 0 0 1];
b = [17600; 21120; 12320];

function [x, y, z, k] = QuadraticOptimization(Q, c, A, b, show)

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
    
    % Compile vector
    xyz = [x; y; z];
    
    % Iterate until done
    finished = false;
    k = 0;
    while ~finished
        
        % Iterate trial
        k = k + 1;
    
        % Get epsilon value based on parity
        eps = mod(k, 2) * eps_min + abs(1 - mod(k, 2)) * eps_max;
    
        % Find avg complementarity
        beta = (z' * x) / n;
    
        % Find F of current vector subject to beta-epsilon
        F = [-Q * x - c + A' * y + z;
             A * x - b;
             (z .* x) - (ones(n, 1) * eps * beta)];
    
        % Find gradient of F
        grad_F = [-Q, A', eye(n);
                  A, zeros(m, m), zeros(m, n);
                  diag(z), zeros(n, m), diag(x)];
        
        % Find vector gradient 
        grad_xyz = -grad_F \ F;
    
        % Find maximum z_i * x_i
        limit = delta * beta;
        limit_vect = ones(n, 1) .* limit;
        
        % Choose alpha
        h = 0.00001;
        alpha = 0;
        in_nbhd = true;
        while alpha <= 1 && in_nbhd 
    
            % Calculate "step"
            xyz_new = xyz + alpha .* grad_xyz;
    
            % Check if new vector is in neighborhood
            in_nbhd = all(xyz_new(1:n, 1) .* xyz_new(n+m+1:n+m+n) ...
                          >= limit_vect);
    
            if in_nbhd
                xyz = xyz_new;
                alpha = alpha + h;
            end
        end
    
        % Calculate new vector
        x = xyz(1:n, 1);
        y = xyz(n+1:n+m, 1);
        z = xyz(n+m+1:n+m+n);
        
        % Check terminating condition
        finished = norm([-Q * x - c + A' * y + z;
                         A * x - b;
                         (z .* x) - (ones(n, 1) * eps * beta)]) < .000001;
        
        % Debugging
        if show
            disp(k)
            disp(norm([-Q * x - c + A' * y + z;
                       A * x - b;
                       (z .* x) - (ones(n, 1) * eps * beta)]))
        disp('------')
        end
    end
end

% Run quadratic program
[x, y, z, k] = QuadraticOptimization(Q, c, A, b, false)
eps_min = 0.1
eps_max = 0.9
delta = 0.5

% Turn off diary
diary off