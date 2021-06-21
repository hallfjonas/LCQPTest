%% Clean and Load
close all; clear all; clc;

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
x = w(1:2);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);

% Objective
obj = 0.5*((x(1) - 1)^2 + (x(2) - 1)^2);

% Complementarities
compl_L = x(1);
compl_R = x(2);
    
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
params.printLevel = 2;
params.x0 = [0.0001; 0.0001];
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