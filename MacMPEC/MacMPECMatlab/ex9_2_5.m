%% Clean and Load
close all; 

% Load Helpers
addpath("helpers");

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

%% Build Problem
% Dimension
nv = 8;
nc = 4;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
s = w(3:5);
l = w(6:8);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1) = 0; ub(1) = 8;
lb(3:8) = 0;

% Objective
obj = (x-3)^2 + (y-2)^2;

% Constraints
constr = {...
    -2*x + y + s(1), ...
    x - 2*y + s(2), ...
    x + 2*y + s(3), ...
    2*(y-5) + l(1) - 2*l(2) + 2*l(3) ...
};
    
lbA = [1; 2; 14; 0]; 
ubA = lbA; 

% Complementarities
compl_L = l;
compl_R = s;
    
% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA ...
);

% Remember the objective's offset term
problem.Obj = Function('Obj', {w}, {obj});

% Add box constraints to problem struct
problem.lb = lb;
problem.ub = ub;


