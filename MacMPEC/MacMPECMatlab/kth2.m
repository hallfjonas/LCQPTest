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
nv = 2;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);

% Objective
obj = (y - 1)^2 + x;

% Get LCQP standard form    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    [], ...
    [], ...
    [], ...
    [], ...
    [], ...
    lb, ...
    ub ...
);

problem.L = [0 1];
problem.R = [1 0];

% Remember phi
problem.Phi = @(x) min((problem.L*x).*(problem.R*x));


