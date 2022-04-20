%% Clean and Load
close all; 

% Load Helpers
addpath("helpers");

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

%% 'Load' Data

sol = [0 3 0 4]';
g = [1 -1 -1 0]';
b = [8 12 12 8 8 5]';
A = [-1 -2 0 0; ...
     -4 -1 0 0; ...
     -3 -4 0 0; ...
     0 0 -2 -1; ...
     0 0 -1 -2; ...
     0 0 -1 -1];

H = [0 0 -1 1; ...
     0 0 1 -1; ...
     -1 1 0 0; ...
     1 -1 0 0];
 
 zl = [0.01 -10 0.1 -1 -1 0.001]';
 zu = [10 -0.01 1 -0.1 1 10]';
 u = [0.2 1.2 2 0.1]';
 v = [1.2 0.2 0.1 2 10 -0.2]';
 
%% Build Problem
nx = 4;
nl = 6;
nm = 4;
nz = 6;

% Dimension
nv = nx + nl + nm + nz;
nc = size(H,1);

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:nx);
l = w(nx+1:nx+nl);
m = w(nx+nl+1:nx+nl+nm);
z = w(nx+nl+nm+1:nx+nl+nm+nz);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
lb(nx+nl+nm+1:nx+nl+nm+nz) = zl;
ub(nx+nl+nm+1:nx+nl+nm+nz) = zu;

% Objective
obj = (x - sol)'*(x - sol);

% Get LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(), ...
    vertcat(), ...
    vertcat(), ...
    [], ...
    [], ...
    lb, ...
    ub ...
);

% Complementarity matrices
problem.L = [zeros(nl,nx), eye(nl, nl), zeros(nl, nv - nx - nl); ...
             eye(nx,nx), zeros(nx, nl), zeros(nx, nv - nx - nl)];
problem.R = [A, zeros(nl, nl), zeros(nl, nm), -diag(v); ...
             zeros(nx,nx), zeros(nx,nl), -eye(nx,nm), zeros(nx, nz)];

problem.lbL = zeros(size(L,1),1);
problem.ubL = inf(size(L,1),1);
problem.lbR = zeros(size(L,1),1);
problem.lbR(1:length(b)) = -b;
problem.ubR = inf(size(L,1),1);

% Linear constraints
% TODO: VERIFY THAT I UNDERSTOOD THIS CORRECTLY
% z and u have 6 elements but only the first 4 are used in A??
problem.A = [H, -A', -eye(nc,nm), diag(u(1:4)), zeros(nc, 2)];
problem.lbA = -g;
problem.ubA = -g;

% Remember phi
problem.Phi = @(x) max((problem.L*x - problem.lbL).*(problem.R*x - problem.lbR));

