% Start diary
echo on
diary HW3prob2.txt

% Define A and c from solution
A = [-0.27 -0.12 -0.045 1 0 0 0; 
     -1 -0.75 -0.2 0 1 0 0; 
     -2 1 0 0 0 1 0;
     0 0 1 0 0 0 1]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]

% Row reduce A (yes, it's technically already reduced; still fixes order)
A = rref(A)
