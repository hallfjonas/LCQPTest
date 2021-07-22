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
nv = 3 + 1;
nc = 0;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
u = w(3);
one = w(4);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
ub(1) = 15;
lb(nv) = 1;
ub(nv) = 1;

% Objective
obj = x^2 + (y - 10)^2;

% Complementarities
compl_L = { ...
    4*(x + 2*y - 30*one) + u, ...
    20*one - x - y ...
};   
compl_R = { ...
    y, ...
    u ...
};
    
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
