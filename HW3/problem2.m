% Start diary
echo on
diary HW3prob2.txt

% Define A and c from solution
A = [-0.27 -0.12 -0.045 1 0 0 0; 
     -1 -0.75 -0.2 0 1 0 0; 
     -2 1 0 0 0 1 0;
     0 0 1 0 0 0 1]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]

% Loop through all row combinations of A
combos = nchoosek(1:6, 4)
successes = 0 % Debugging
all_bfvs = []
for i = 1:size(combos, 1)

    % Filter A and reduce
    combo = combos(i,1:size(combos, 2))
    A_selected = rref(A(1:size(A, 1), combo))

    % If reduced columns are lin indep, continue
    if A_selected == eye(4)
        successes = successes + 1 % Debugging
        
        % Find c_b by multiplying selected values by A_inverse
        A_selected_inv = inv(A(1:size(A, 1), combo))
        c_b = A_selected_inv * c(combo, 1:size(c, 2))

        % Create copy of c, replace w/ c_b and supplement w/ zeros
        c_new = c
        c_new(combo) = c_b
        c_new(~combo) = 0
        
        % Add to total array
        all_bfvs = [all_bfvs c_new]

    else
        
    end
end
