function [problem] = BuildAndSolveFLP4(dataFile)

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

% Load AMPL
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab/");
setUp;
ampl = AMPL("/home/jonas/amplide.linux64/ampl.linux-intel64/");

%% Load Data
ampl.read("data/flp4.mod");
ampl.readData(['data/', dataFile]);
LoadAMPLParams(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
% Dimension
nv = n + m;
nc = p;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:n);
y = w(n+1:n+m);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);

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
    [], ...
    lb, ...
    ub ...
);

% Complementarity matrices
problem.L = [zeros(size(N)), eye(size(M))];
problem.R = [N, M];
problem.lbL = zeros(size(q));
problem.lbR = -q;

% Linear constraints
problem.A = [A, zeros(nc, m)];
problem.lbA = -inf(nc, 1);
problem.ubA = b;

% Remember the objective's offset term
problem.Obj = Function('Obj', {w}, {obj});
problem.Phi = @(x) max((problem.L*x - problem.lbR).*(problem.R*x - problem.lbR));

end