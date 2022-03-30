function [solution] = SolveLCQP_Sparse(name)

import casadi.*;

addpath("~/LCQPow/build/lib");
currdir = pwd;
cd MacMPECMatlab;
run([name, '.m']);
cd(currdir);

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

% Convert to sparse matrices
problem.Q = sparse(problem.Q);
problem.A = sparse(problem.A);
problem.L = sparse(problem.L);
problem.R = sparse(problem.R);

% Solve LCQP
params.printLevel = 0;
params.qpSolver = 1;
tic;
[solution.x,solution.y,solution.stats] = LCQPow(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    [], [], [], [], ...
    problem.A, ...
    problem.lbA, ...
    problem.ubA, ...
    problem.lb, ...
    problem.ub, ...
    params ...
);
solution.stats.elapsed_time_w_overhead = toc;

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

