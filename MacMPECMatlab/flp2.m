%% Clean and Load
close all; clear all; clc;

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

%% Build Problem
% Dimension
nv = 4 + 1;
nc = 0;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:2);
y = w(3:4);
one = w(5);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
ub(1:2) = [10; 10];
lb(5) = 1;
ub(5) = 1;

% Objective
obj = 0.5*( (x(1)+x(2)+y(1)-15)^2 + (x(1)+x(2)+y(2)-15)^2 );

% Complementarities
compl_L = y;
compl_R = {...
    8/3*x(1) + 2*x(2) + 2*y(1) + 8/3*y(2) - 36*one, ...
    2*x(1) + 5/4*x(2) + 5/4*y(1) + 2*y(2) - 25*one ...
};
    
% Build LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    [], ...
    [] ...
);

% Regularization
problem.Q = problem.Q + 10*eps*eye(nv);

% Solve
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

    
