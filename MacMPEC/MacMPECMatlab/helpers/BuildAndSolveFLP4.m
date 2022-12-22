function [problem] = BuildAndSolveFLP4(dataFile)

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

% Load AMPL
addpath("~/ampl/ampl.linux-intel64/amplapi/matlab/");
setUp;
ampl = AMPL;

%% Load Data
ampl.read("data/flp4.mod");
ampl.readData(['data/', dataFile]);
LoadAMPLParams(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
% Dimension
nv = n + m + 1;
nc = p;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:n);
y = w(n+1:n+m);
one = w(n+m+1);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(nv) = 1;
ub(nv) = 1;

% Objective
obj = 0.5*(x'*x) + sum(y);

% Complementarities
compl_L = y;
compl_R = N*x + M*y + one*q;

% Linear Constraints
constr = A*x;
lbA = -inf(nc, 1);
ubA = b;

% Build LCQP
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

end