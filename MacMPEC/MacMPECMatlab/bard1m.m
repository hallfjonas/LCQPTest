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
nx = 1;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
l1 = w(3);
l2 = w(4);
l3 = w(5);
three = w(6);
four = w(7);
seven = w(8);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1) = 0;
lb(2) = 0;
lb(6) = 3;
ub(6) = 3;
lb(7) = 4;          
ub(7) = 4;
lb(8) = 7;          
ub(8) = 7;

% Objective
obj = (x - 5)^2 + (2*y + 1)^2;

% Constraints
constr = {...
    (((2*(y-1)-1.5*x)-l1*(-1)*1)-l2*0.5)-l3*(-1)*1, ...
};
lbA = 0;
ubA = inf;

% Complementarities
compl_L = {3*x - y - three, -x + 0.5*y + four, -x - y + seven};
compl_R = {l1, l2, l3};
    
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

