% Turn on scientific notation
format longG

% Turn on diary
diary HW9prob3.txt

function [output] = NewtonRosenbrock(start, numiter)
    vect = start;
    output = vect';
    
    % Loop
    for i = 1:numiter
        
        % Assign x, y
        x = vect(1);
        y = vect(2);

        % Calculate gradient and Hessian
        grad = [400*x^3 + 2*x - 2 - 400*x*y;
                -200*x^2 + 200*y];
        hess = [1200*x^2 + 2 - 400*y, -400*x;
                -400*x, 200];

        % Calculate new vector
        vect = [x; y] - inv(hess) * grad;
        output = [output; vect'];

    end
end

% Run program
output = NewtonRosenbrock([26; 100], 5);
disp("Final vector")
disp(output(6, :))

% Plot and save
fig = scatter(output(:, 1), output(:, 2), 18, 'magenta', 'filled');
saveas(fig, "prob3.png")

% Turn off diary
diary off