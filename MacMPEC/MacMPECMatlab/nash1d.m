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
nv = 2 + 2 + 2 + 1;
nc = 2;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:2);
y = w(3:4);
l = w(5:6);
one = w(nv);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
ub(1:2) = [10; 10];
lb(3:4) = -inf(2,1);
lb(nv) = 1; 
ub(nv) = 1;

% Objective
obj = ( (x(1) - y(1))^2 + (x(2) - y(2))^2 )/2;

% Constraints
constr = {...
    2*y(1) + (8/3)*y(2)   - ( -l(1) ), ...
    1.25*y(1) + 2*y(2) - ( -l(2) ) ...
};
    
lbA = [34; 24.25]; 
ubA = lbA;

% Complementarities
compl_L = {...
    -x(2) - y(1) + 15*one, ...
    -x(1) - y(2) + 15*one ...
};

compl_R = l;
    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA ...
);

problem.x0 = zeros(nv,1);
problem.x0(1:2) = [10; 0];
