%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

%% Build Problem
% Dimension
nv = 3;
nc = 1;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
l = w(3);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
ub(1) = 200;

% Objective
obj = 0.5*x^2 + 0.5*x*y - 95*x;

% Constraints
constr = {...
    2*y + 0.5*x - l ...
};
    
lbA = [100]; 
ubA = lbA; 

% Complementarities
compl_L = y;
compl_R = l;
    
% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA ...
);

% Solve LCQP
params.printLevel = 2;
x = LCQPow(...
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

% Print objective at solution
problem.obj(x)