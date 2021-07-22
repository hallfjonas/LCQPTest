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
nv = 8;
nc = 5;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2:3);
s = w(4:5);
l = w(6:7);
l1 = w(8);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(1:7) = zeros(7,1);

% Objective
obj = 0.5*(y(1)- 2)^2 + 0.5*(y(2)-2)^2;

% Constraints
constr = {...
    -x + y(1) + y(2), ...
    -y(1) + s(1), ...
    -y(2) + s(2), ...
    y(1) + l1 - l(1), ...
    1 + l1 - l(2) ...
};
    
lbA = zeros(nc,1); 
ubA = lbA;

% Complementarities
compl_L = s;
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
