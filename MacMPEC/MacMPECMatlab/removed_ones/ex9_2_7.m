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
nv = 10;
nc = 5;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
s = w(3:6);
l = w(7:10);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1:2) = zeros(2,1);

% Objective
obj = (x-5)^2 + (2*y + 1)^2;

% Constraints
constr = {...
    -3*x + y + s(1), ...
    x - 0.5*y + s(2), ...
    x + y + s(3), ...
    -y + s(4), ...
    2*(y-1) - 1.5*x + l(1) - 0.5*l(2) + l(3) - l(4) ...
};
    
lbA = [-3; 4; 7; 0; 0]; 
ubA = lbA; 

% Complementarities
compl_L = s;
compl_R = l;
    
% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA, ...
    lb, ...
    ub ...
);



