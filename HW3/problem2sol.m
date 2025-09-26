% Define A and c from solution, set up "c-zero" vector
A = [0.27 0.12 0.045 1 0 0 0; 
     1 0.75 0.2 0 1 0 0; 
     2 -1 0 0 0 1 0;
     0 0 1 0 0 0 1]
b = [100; 480; 0; 300]
c = [-200.2; -50.2; -25.2; 0; 0; 0; 0]
bfvs = []

% Iterate
for i=1:7
    for j=(i+1):7
        for k=(j+1):7
            for u=(k+1):7
                    
                    % Isolate matrix, calculate x_b
                    B = A(:,[i j k u])
                    x_b = B\b

                    if all(x_b >= 0)
                        
                        % Calculate new BFV
                        new_vector = [0; 0; 0; 0; 0; 0; 0]
                        new_vector([i j k u]) = x_b

                        % Add to collection
                        bfvs = [bfvs; new_vector']
                    end

            end
        end
    end
end
