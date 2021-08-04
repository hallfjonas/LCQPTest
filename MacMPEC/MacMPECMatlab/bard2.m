%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

%% Build Problem
% Dimension
nv = 12;
nc = 5;

% Variables and box constraints
w = SX.sym('w', nv, 1);
y = w(1:4);
x = w(5:8);
l = w(9:12);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1:8) = zeros(8,1);
ub(1:4) = [20; 20; 40; 40];
ub(5:8) = [10; 5; 15; 20];

% Objective
obj = -( (200 - y(1) - y(3))*(y(1) + y(3)) + (160 - y(2) - y(4))*(y(2) + y(4)) );

% Constraints
constr = {...
    x(1) + x(2) + x(3) + x(4), ...
    2*(y(1) - 4) + l(1)*0.4 + l(2)*0.6, ...
    2*(y(2) - 13) + l(1)*0.7 + l(2)*0.3, ...
    2*(y(3) - 35) + l(3)*0.4 + l(4)*0.6, ...
    2*(y(4) - 2) + l(3)*0.7 + l(4)*0.3 ...
};
    
lbA = zeros(nc,1); 
ubA = zeros(nc,1); 
lbA(1) = -inf; ubA(1) = 40;

% Complementarities
compl_L = {...
    x(1) - 0.4*y(1) - 0.7*y(2), ...
    x(2) - 0.6*y(1) - 0.3*y(2), ...
    x(3) - 0.4*y(3) - 0.7*y(4), ...
    x(4) - 0.6*y(3) - 0.3*y(4) ...
};

compl_R = {l(1), l(2), l(3), l(4)};
    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA ...
);