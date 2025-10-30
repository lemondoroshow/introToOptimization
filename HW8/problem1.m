% Turn on diary
diary HW8prob1.txt

%% First trial

% Set matrices
B = [1, 2;
     2, 4];
A = B + 7 * eye(2)

% Get and display eigenvalues
eigen_B = eig(B)
eigen_A = eig(A)

% Get 100 random vectors
v = [];
for i = 1:100
    d = randn(2, 1);
    
    % Calculate quantity and add to v
    v = [v, 1 / (d' * d) * d' * A * d];
    
end

% Plot v
fig = plot(v, zeros(1, 100), 'r.');
saveas(fig, "prob1trial1.png")

%% Second trial

% Set matrices
B = [1, 2;
     2, 4];
A = 2 * B + 3 * eye(2)

% Get and display eigenvalues
eigen_B = eig(B)
eigen_A = eig(A)

% Get 100 random vectors
v = [];
for i = 1:100
    d = randn(2, 1);
    
    % Calculate quantity and add to v
    v = [v, 1 / (d' * d) * d' * A * d];
    
end

% Plot v
fig = plot(v, zeros(1, 100), 'r.');
saveas(fig, "prob1trial2.png")

%% Turn off diary
diary off