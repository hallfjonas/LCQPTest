function [solution] = SolveLCQP_OSQP(name)

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

if (exist('lb', 'var') && exist('ub', 'var'))
    problem.A = [problem.A; eye(length(lb))];
    problem.lbA = [problem.lbA; lb];
    problem.ubA = [problem.ubA; ub];
end

% Convert to sparse matrices
problem.Q = sparse(problem.Q);
problem.A = sparse(problem.A);
problem.L = sparse(problem.L);
problem.R = sparse(problem.R);

% Solve LCQP
params.printLevel = 0;
params.qpSolver = 2;
%params.OSQP_options = osqp.default_settings();
%params.OSQP_options.polish = 1;

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
    params ...
);
solution.stats.elapsed_time_w_overhead = toc;
solution.stats.obj = full(problem.Obj(solution.x));
solution.stats.compl = full(problem.Phi(solution.x));

end

