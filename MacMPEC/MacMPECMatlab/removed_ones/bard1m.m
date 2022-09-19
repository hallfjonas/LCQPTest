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
nv = 6;
nx = 1;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
l1 = w(3);
l2 = w(4);
l3 = w(5);
sy = w(6);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);

% Objective
obj = (x - 5)^2 + (2*y + 1)^2;

% Constraints
constr = {...
    (((2*(y-1)-1.5*x)-l1*(-1)*1)-l2*0.5)-l3*(-1)*1-sy, ...
};
lbA = 0;
ubA = 0;

% Complementarities
compl_L = {3*x - y - 3, -x + 0.5*y + 4, -x - y + 7};
compl_R = {l1, l2, l3};
    
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