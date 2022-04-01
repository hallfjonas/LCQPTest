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

% Remember the objective's offset term
problem.Obj = Function('Obj', {w}, {obj});



    
