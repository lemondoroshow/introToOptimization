% Start diary
echo on
diary HW3prob2.txt

% Define A and c from solution, set up "c-zero" vector
A = [-0.27 -0.12 -0.045 1 0 0 0; 
     -1 -0.75 -0.2 0 1 0 0; 
     -2 1 0 0 0 1 0;
     0 0 1 0 0 0 1]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]
c_z = zeros(size(c, 1), 1)

% Loop through all row combinations of A
combos = nchoosek(1:size(A, 2), size(A, 1))
successes = 0 % Debugging
all_bfvs = []
for i = 1:size(combos, 1)

    % Filter A
    combo = combos(i,1:size(combos, 2))
    A_selected = A(1:size(A, 1), combo)

    % If reduced columns are lin indep, continue
    if rref(A_selected) == eye(size(A, 1))
        
        % Find c_b by multiplying selected values by A_inverse
        A_selected_inv = inv(A(1:size(A, 1), combo))
        c_b = A_selected_inv * c(combo, 1:size(c, 2))
        
        % If all elements are non-negative, continue
        if all(c_b >= 0)
            successes = successes + 1 % Debugging

            % Create zero vector, replace values
            c_new = c_z
            c_new(combo) = c_b
        
            % Add to totaL
            all_bfvs = [all_bfvs; c_new']
        end
    end
end

% End diary
diary off