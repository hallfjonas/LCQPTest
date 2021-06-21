function [x, problem] = BuildAndSolveRalphmod(dataFile)

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
ampl.read("data/ralphmod.mod");
ampl.readData(['data/', dataFile]);
LoadAMPLParams(ampl);
LoadAMPLSets(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
% Dimension
nx = length(design);
ny = length(state);
nv = nx + ny + 1;
ncomp = ny;
w = SX.sym('w', nv, 1);
x = w(1:nx);
y = w(nx+1:nx+ny);
one = w(nv);
lb = zeros(nv,1);
ub = inf(nv,1);
ub(1:nx) = 1000*ones(nx,1);
lb(nv) = 1;
ub(nv) = 1;

problem.Q = blkdiag(P, eps);
problem.g = [c; 0];

problem.L = [M(state,:) q(state)];
problem.R = [zeros(ncomp, nx) eye(ny) zeros(ncomp,1)];

problem.obj = @(x) 1/2*x'*problem.Q*x + g'*x;

% Solve
params.printLevel = 3;
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

end