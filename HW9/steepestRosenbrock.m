function [output] = steepest_descent(start, numiter)

    % Get initial guess
    % ofv = (1 - start(1))^2 + 100 * (start(2) - start(1)^2)^2;
    vect = start;

    % Loop numiter times
    for i = 1:numiter
        
        % Define u, v (components of x)
        u = vect(1);
        v = vect(2);
        
        % Define u, v as negative gradient
        a = -400*u^3 - 2*u + 2 + 400*u*v;
        b = 200*u^2 - 200*v;

        % Solve using approach from problem 1
        grad_coef = [400*a^4, ...
                    -600 * (b - 2*a*u) * a^2, ...
                     200 * (b - 2*a*u)^2 - 400 * (v - u^2) * a^2 + 2*a^2, ...
                     200 * (v - u^2) * (b - 2*a*u) - 2 * (1-u) * a];
        alphas = roots(grad_coef);
        
        % Define function coefficients
        func_coef = [100*a^4, ...
                    -200 * (b - 2*a*u) * a^2, ...
                     100 * (b - 2*a*u)^2 - 200 * (v - u^2) * a^2 + a^2, ...
                     200 * (v - u^2) * (b - 2*a*u) - 2 * (1-u) * a];
        
        % Loop through roots
        res = [];
        for i = 1:size(alphas, 1)
        
            % Calculate function value
            alpha = alphas(i, 1);
            val = func_coef * [alpha ^ 4; alpha ^ 3; alpha ^ 2; alpha];
        
            % Add to matrix
            res = [res; 
                  [alpha, val]];
        
        end

        % Find optimal alpha
        alpha_star = res(res(:, 2) == min(res(:, 2)), 1);

        % Calculate next vector
        vect = [u; v] + alpha_star * [a; b];
        output = vect
        
    end
end

output = steepest_descent([9; 8], 4);