%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

%% Build Problem
% Dimension
nv = 20 + 1;
nc = 5;

% Variables and box constraints
w = SX.sym('w', nv, 1);
y = w(1:4);
x = w(5:8);
l = w(9:20);
one = w(21);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1:8) = zeros(8,1);
ub(5:8) = [10; 5; 15; 20];
lb(21) = 1; ub(21) = 1;

% Objective
obj = -( (200 - y(1) - y(3))*(y(1) + y(3)) + (160 - y(2) - y(4))*(y(2) + y(4)) );

% Constraints
constr = {...
    x(1) + x(2) + x(3) + x(4), ...
    y(1) - 4 - (l(3) - l(4) - l(1)*0.4 - l(2)*0.6), ...
    y(2) - 13 - (l(5) - l(6) - l(1)*0.7 - l(2)*0.3), ...
    y(3) - 35 - (l(9) - l(10) - l(7)*0.4 - l(8)*0.6), ...
    y(4) - 2 - (l(11) - l(12) - l(7)*0.7 - l(8)*0.3) ...
};
    
lbA = zeros(nc,1); 
ubA = zeros(nc,1); 
lbA(1) = -inf; ubA(1) = 40;

% Complementarities
compl_L = {...
    x(1) - 0.4*y(1) - 0.7*y(2), ...
    x(2) - 0.6*y(1) - 0.3*y(2), ...
    y(1), ...
    -y(1) + 20*one, ...
    y(2), ...
    -y(2) + 20*one, ...
    x(3) - 0.4*y(3) - 0.7*y(4), ...
    x(4) - 0.6*y(3) - 0.3*y(4), ...
    y(3), ...
    -y(3) + 40*one, ...
    y(4), ...
    -y(4) + 40*one ...
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
