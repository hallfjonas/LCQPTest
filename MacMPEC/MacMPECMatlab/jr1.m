%% Clean and Load
close all; 

% Load CasADi
import casadi.*;

%% Build Problem
% Dimension
nv = 2;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);

% Objective
obj = (x - 1)^2 + y^2;

%Complementarities
compl_L = y;
compl_R = y - x;

% Get LCQP standard form    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    [], ...
    compl_L, ...
    compl_R, ...
    [], ...
    [], ...
    lb, ...
    ub ...
);
