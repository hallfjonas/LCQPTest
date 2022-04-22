function [solution] = SolveLCQPSmallRho0(name)

import casadi.*;

addpath("~/LCQPow/build/lib");
currdir = pwd;
cd MacMPECMatlab/;
run([name, '.m']);
cd(currdir);

if (~isfield(problem, 'A'))
    problem.A = [];
    problem.lbA = [];
    problem.ubA = [];
end

% Solve LCQP
params.printLevel = 0;
params.initialPenaltyParameter = 10e-10;

% params.stationarityTolerance = 10e-6;
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

solution.stats.obj = full(problem.Obj(solution.x));
solution.stats.compl = full(problem.Phi(solution.x));
solution.stats.n_x = size(problem.Q, 1);
solution.stats.n_c = size(problem.A, 1);
solution.stats.n_comp = size(problem.L, 1);

end

