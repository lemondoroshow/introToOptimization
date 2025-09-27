% Start diary
echo on
diary HW4prob1.txt

% Define A, b, c
A = [0.27 0.12 0.045 1 0 0 0; 
     1 0.75 0.2 0 1 0 0; 
     2 -1 0 0 0 1 0;
     0 0 1 0 0 0 1]
b = [100; 480; 0; 300]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]
bfvs = []
ofvs = []
r_nTs = []
selected_columns = []

% Iterate
for i = 1:7
    for j = (i + 1):7
        for k = (j + 1):7
            for u = (k + 1):7
                    
                    % Isolate matrix, calculate x_b
                    B = A(:, [i j k u])
                    N = A(:, setdiff(1:7, [i j k u]))
                    x_b = B \ b

                    if all(x_b >= 0)
                        
                        % Calculate new BFV
                        new_vector = [0; 0; 0; 0; 0; 0; 0]
                        new_vector([i j k u],:) = x_b

                        % Calculate objective function value
                        c_b = c([i j k u],:)
                        ofv = c_b' * x_b

                        % Calculate reduced costs
                        c_n = c(setdiff(1:7, [i j k u]),:)
                        r_n = (c_n' - c_b' * inv(B)  * N)'

                        % Add to collections
                        bfvs = [bfvs; new_vector']
                        ofvs = [ofvs; ofv]
                        r_nTs = [r_nTs; r_n']
                        selected_columns = [selected_columns; [i j k u]]
                        
                    end

            end
        end
    end
end

% End diary
diary off