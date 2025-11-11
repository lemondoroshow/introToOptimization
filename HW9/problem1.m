% Turn off scientific notation
format shortG

% Turn on diary
diary HW9prob1.txt

% Define input vectors
all_uv = [1.2, 1.4;
          2.2, -1.5;
          10, 20];
all_ab = [-1, 1;
           3, 5;
          -1, 3];

for loop = 1:3
    
    % Define other input vectors
    uv = all_uv(loop, :)';
    ab = all_ab(loop, :)';

    % Isolate components
    u = uv(1, 1);
    v = uv(2, 1);
    a = ab(1, 1);
    b = ab(2, 1);
    
    % Solve for alpha according to following:
    % alpha-cubed: (400a^4)
    % alpha-squared: (-600(b-2au)a^2)
    % alpha: (200(b-2au)^2-400(v-u^2)a^2+2a^2)
    % none: (200(v-u^2)(b-2au)-2(1-u)a)
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
    
    % Display results
    disp('-----------')
    disp('u, v')
    disp(uv)
    disp('a, b')
    disp(ab)
    disp('alphas, OFV')
    disp(res)
    alpha_star = res(res(:, 2) == min(res(:, 2)), 1)
    disp('-----------')

end

% Turn off diary
diary off