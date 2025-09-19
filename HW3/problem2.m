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
for i = 1:size(combos, 1)

    % Filter A and reduce
    combo = combos(i,1:size(combos, 2))
    A_selected = rref(A(1:size(A, 1), combo))

    % If reduced columns are lin indep, continue
    if A_selected == eye(4)
        success = true
        successes = successes + 1 % Debugging
            
    else
        success = false
    end
end
