function [x, problem] = BuildAndSolveRalphmod(dataFile)

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
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
nv = nx + ny;
ncomp = ny;
w = SX.sym('w', nv, 1);
x = w(1:nx);
y = w(nx+1:nx+ny);

lb = zeros(nv,1);
ub = inf(nv,1);
ub(1:nx) = 1000*ones(nx,1);

problem.Q = P;
problem.g = c;

problem.L = M(state,:);
problem.R = [zeros(ncomp, nx) eye(ny)];
problem.lbL = -q(state);
problem.lbR = zeros(ncomp,1);

problem.obj = @(x) 1/2*x'*problem.Q*x + g'*x;

% Solve
params.printLevel = 3;
x = LCQPow(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    lb, ...
    ub, ...
    params ...
);

end