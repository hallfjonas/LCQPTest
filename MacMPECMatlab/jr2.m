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

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);

% Objective
obj = (y - 1)^2 + x^2;

% Get LCQP standard form    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    [], ...
    [], ...
    [], ...
    [], ...
    [] ...
);

problem.L = [0 1];
problem.R = [-1 1];

params.printLevel = 2;
x = LCQPanther(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    lb, ...
    ub, ...
    params ...
);
problem.obj(x)

    