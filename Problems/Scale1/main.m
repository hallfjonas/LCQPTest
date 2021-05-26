%% Build a simple poorly scaled warm up problem

% Simple QP
Q = [2*100^2 0; 0 2];
g = [-200; -2];
L = [1 0];
R = [0 1];

% Algorithm parameters (C++)
params.x0 = [1; 1];
params.initialPenaltyParameter = 1;
params.penaltyUpdateFactor = 2;
params.solveZeroPenaltyFirst = true;
params.printLevel = 2;
