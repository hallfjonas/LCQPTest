function [solution] = SolveLCQP_Sparse(name)

import casadi.*;

addpath("~/LCQPow/build/lib");
cd MacMPECMatlab;
run([name, '.m']);
cd ..;

if (~isfield(problem, 'A'))
    problem.A = [];
    problem.lbA = [];
    problem.ubA = [];
end

if (~exist('lb'))
    lb = [];
end

if (~exist('ub'))
    ub = [];
end

problem.lb = lb;
problem.ub = ub;

% Solve LCQP
params.printLevel = 0;
params.qpSolver = 1;
[solution.x,solution.y,solution.stats] = LCQPow(...
    sparse(problem.Q), ...
    problem.g, ...
    sparse(problem.L), ...
    sparse(problem.R), ...
    [], [], [], [], ...
    sparse(problem.A), ...
    problem.lbA, ...
    problem.ubA, ...
    problem.lb, ...
    problem.ub, ...
    params ...
);

if (exist('w'))
    Obj = Function('Obj', {w}, {obj});
else
    Obj = @(x) 1/2*x'*problem.Q*x + problem.g'*x;
end
solution.stats.obj = full(Obj(solution.x));

solution.stats.n_x = size(problem.Q, 1);
solution.stats.n_c = size(problem.A, 1);
solution.stats.n_comp = size(problem.L, 1);

end

