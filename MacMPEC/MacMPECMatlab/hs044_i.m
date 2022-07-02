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

I = 1:4;

%% Build Problem
nx = 4;
nl = 6;
nm = 4;
nz = 6;

% Dimension
nv = nx + nl + nm + nz + 1;
nc = size(H,1);

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:nx);
l = w(nx+1:nx+nl);
m = w(nx+nl+1:nx+nl+nm);
z = w(nx+nl+nm+1:nx+nl+nm+nz);
one = w(nv);

% Box Constraints
lb = zeros(nv,1);
ub = inf(nv,1);
lb(nx+nl+nm+1:nx+nl+nm+nz) = zl;
ub(nx+nl+nm+1:nx+nl+nm+nz) = zu;
lb(nv) = 1; 
ub(nv) = 1;

% Objective
obj = (x - sol)'*(x - sol);

% Compllementarities
compl_L = {
    l, ...
    x, ...
};
compl_R = {
    b*one - v.*z + A*x, ...
    m, ...
};

% Linear constraints
lbA = -g;
ubA = -g;
constr = {H*x + u(I).*z(I) - A'*l - m};

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

