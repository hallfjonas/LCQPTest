%% Build a simple warm up problem
Q = [2 0; 0 2];
g = [-2; -2];
L = [1 0];
R = [0 1];
lb = [-inf; -inf];
ub = [inf; inf];

% Algorithm parameters (C++)
params.x0 = [1; 1];
params.initialPenaltyParameter = 0.01;
params.penaltyUpdateFactor = 2;
