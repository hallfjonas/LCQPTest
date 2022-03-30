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
nv = 2;
nc = 0;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:2);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);

% Objective
a = 100;
obj = (a*x(1) - 1)^2 + a*(x(2) - 1)^2;

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
