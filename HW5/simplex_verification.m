% Turn on diary
diary HW5prob4verification.txt

% Define A, b, c
load("prob4datafile.mat")
bfvs = [];
ofvs = [];
r_nTs = [];
selected_columns = [];

% Iterate
for i = 1:8
    for j = (i + 1):8
        for k = (j + 1):8
            for u = (k + 1):8
                for v = (k+1):8
                    
                    % Isolate matrix, calculate x_b
                    B = A(:, [i j k u v]);
                    N = A(:, setdiff(1:8, [i j k u v]));
                    x_b = B \ b;

                    if all(x_b >= 0)
                        
                        % Calculate new BFV
                        new_vector = [0; 0; 0; 0; 0; 0; 0];
                        new_vector([i j k u v],:) = x_b;

                        % Calculate objective function value
                        c_b = c([i j k u v],:);
                        ofv = c_b' * x_b;

                        % Calculate reduced costs
                        c_n = c(setdiff(1:8, [i j k u v]),:);
                        r_n = (c_n' - c_b' * inv(B)  * N)';

                        % Add to collections
                        % bfvs = [bfvs; new_vector'];
                        ofvs = [ofvs; ofv];
                        r_nTs = [r_nTs; r_n'];
                        selected_columns = [selected_columns; [i j k u v]];
                        
                    end
                end
            end
        end
    end
end

% Output results
disp(bfvs)
disp(ofvs)
disp(r_nTs)

% Turn off diary
diary off