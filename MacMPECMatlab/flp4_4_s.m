%% Clean and Load
close all; clear all; clc;

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

% Load AMPL
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab/");
setUp;
ampl = AMPL;

% Load Helpers
addpath("helpers");

%% Load Data
ampl.read("data/flp4.mod");
ampl.readData("data/flp4-s-4.dat");
amplparams = LoadAMPLParams(ampl);

n = amplparams('n');
m = amplparams('m');
p = amplparams('p');
N = amplparams('N');
M = amplparams('M');
q = amplparams('q');
A = amplparams('A');
b = amplparams('b');

%% Build Problem
% Dimension
nv = n + m + 1;
nc = length(amplparams('b'));
ncomp = size(amplparams('N'),1);

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
problem.Q = problem.Q + 10*eps*eye(nv,nv);

% Complementarity matrices
problem.L = [zeros(size(N)), eye(size(M)), zeros(size(q))];
problem.R = [N, M, q];

% Linear constraints
problem.A = [A, zeros(p, m+1)];
problem.lbA = -inf(nc, 1);
problem.ubA = b;

% Solve
params.printLevel = 2;
params.qpSolver = 1;
x = LCQPanther(...
    sparse(problem.Q), ...
    problem.g, ...
    sparse(problem.L), ...
    sparse(problem.R), ...
    sparse(problem.A), ...
    problem.lbA, ...
    problem.ubA, ...
    lb, ...
    ub, ...
    params ...
);
problem.obj(x)

% Close the AMPL object
ampl.close();

    
