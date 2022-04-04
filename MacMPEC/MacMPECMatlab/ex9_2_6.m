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
nv = 16;
nc = 6;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:2);
y = w(3:4);
s = w(5:10);
l = w(11:16);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);

% Objective
obj = x(1)*x(1) - 2*x(1) + x(2)*x(2) - 2*x(2) + y(1)*y(1) + y(2)*y(2);

% Constraints
constr = {...
    0.5 - y(1) + s(1), ...
    0.5 - y(2) + s(2), ...
    y(1) - 1.5 + s(3), ...
    y(2) - 1.5 + s(4), ...
    2*(y(1) - x(1)) - l(1) + l(3), ...
    2*(y(2) - x(2)) - l(2) + l(4) ...
};
    
lbA = [0; 0; 0; 0; 0; 0]; 
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


