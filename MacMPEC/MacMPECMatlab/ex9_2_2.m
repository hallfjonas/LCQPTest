%% Clean and Load
close all; 

% Load CasADi
import casadi.*;

%% Build Problem
% Dimension
nv = 8;
nc = 5;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1);
y = w(2);
s = w(3:5);
l = w(6:8);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
ub(1) = 15;

% Objective
obj = x^2 + (y-10)^2;

% Constraints
constr = {...
    -x + y, ...
    x + y + s(1), ...
      - y + s(2), ...
        y + s(3), ...
    2*(x + 2*y - 30) + l(1) - l(2) + l(3), ...
};
    
lbA = zeros(nc,1);
lbA(1) = -inf;
lbA(2) = 20;
lbA(3) = 0;
lbA(4) = 20;
lbA(5) = 0;
ubA = zeros(nc,1);
ubA(1) = 0;
ubA(2) = 20;
ubA(3) = 0;
ubA(4) = 20;
ubA(5) = 0;

% Complementarities
compl_L = l;
compl_R = s;
    
% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA, ...
    lb, ...
    ub ...
);

% With the below code we can verify that the solution is M-stationary
% but certainly not S-Stationary.
% sol1 = [10,10,0,10,10,0,0,0]';
% B = [problem.A', problem.L', problem.R'];
% rhs = problem.Q*sol1 + problem.g;
% ysol = B\rhs;
