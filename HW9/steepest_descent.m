% Turn on scientific notation
format longG

% Turn on diary
diary HW9prob2.txt

function [output] = steepestRosenbrock(start, numiter)
    vect = start;
    output = vect';

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
        output = [output; vect'];
        
    end
end

% Run program
output = steepestRosenbrock([26; 100], 31000);
disp("Final vector")
disp(output(31001, :))

% Plot and save
fig = scatter(output(:, 1), output(:, 2), 18, 'magenta', 'filled');
saveas(fig, "prob2.png")

% Turn off diary
diary off