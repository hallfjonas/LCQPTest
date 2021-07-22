function [problem] = BuildAndSolveFLP4(dataFile)

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

% Load AMPL
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab/");
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

% Build LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(), ...
    vertcat(), ...
    vertcat(), ...
    [], ...
    [] ...
);

% Regularization
problem.Q(n+1:nv, n+1:nv) = 10*eps*eye(nv-n,nv-n);

% Complementarity matrices
problem.L = [zeros(size(N)), eye(size(M)), zeros(size(q))];
problem.R = [N, M, q];

% Linear constraints
problem.A = [A, zeros(p, m+1)];
problem.lbA = -inf(nc, 1);
problem.ubA = b;


end