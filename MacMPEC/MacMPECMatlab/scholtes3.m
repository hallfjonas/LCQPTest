%% Clean and Load
close all; 

% Load CasADi
import casadi.*;

%% Build Problem
% Dimension
nv = 2;
nc = 0;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:2);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);

% Objective
obj = 0.5*((x(1) - 1)^2 + (x(2) - 1)^2);

% Complementarities
compl_L = x(1);
compl_R = x(2);
    
% Initial guess
x0 = [0.0001; 0.0001];

% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    [], ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    [], ...
    [], ...
    lb, ...
    ub, ...
    x0 ...
);
