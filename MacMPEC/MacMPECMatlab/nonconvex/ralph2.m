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
nv = 2;
nc = 0;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);

% Box Constraints
lb = [0; -inf];
ub = inf(nv,1);

% Objective
obj = x^2 + y^2 - 4*x*y;

% Complementarities
compl_L = x;
compl_R = y;
    
% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    [], ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    [], ...
    [] ...
);

% Solve LCQP
params.printLevel = 3;
params.x0 = [1; 1];
x = LCQPanther(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    lb, ...
    ub, ...
    params ...
);

% Print objective at solution
problem.obj(x)