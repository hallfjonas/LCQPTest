%% Clean and Load
close all; clear all; clc;

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

%% Build Problem
% Dimension
nv = 5 + 1;
nc = 1;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
l1 = w(3);
l2 = w(4);
l3 = w(5);
one = w(6);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1) = 0;
lb(2) = 0;
lb(6) = 1;
ub(6) = 1;

% Objective
obj = (x - 5)^2 + (2*y + 1)^2;

% Constraints
constr = {2*(y - 1) - 1.5*x + l1 - l2*0.5 + l3};
lbA = 0;
ubA = 0;

% Complementarities
compl_L = {3*x - y - 3*one, -x + 0.5*y + 4*one, -x - y + 7*one};
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

params.printLevel = 2;
x = LCQPanther(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    problem.A, ...
    problem.lbA, ...
    problem.ubA, ...
    lb, ...
    ub, ...
    params ...
);
problem.obj(x)

    
