function [solution] = SolveNLP(name)

import casadi.*

%% Get formulation
run(['MacMPECMatlab/', name, '.m']);
IPOPT_formulation = GetNLPFormulation(problem);

%% Create NLP solver
opts_ipopt = struct;
opts_ipopt.ipopt.nlp_scaling_method = 'none';
opts_ipopt.ipopt.print_level = 0;
opts_ipopt.ipopt.bound_relax_factor = eps;
opts_ipopt.print_time = 1;
opts_ipopt.print_out = 0;
opts_ipopt.ipopt.mu_strategy = 'adaptive';
opts_ipopt.ipopt.mu_oracle = 'quality-function';
opts_ipopt.ipopt.tol = 1e-16;

nlp = struct(...
    'f', IPOPT_formulation.obj, ...
    'x', IPOPT_formulation.x, ...
    'g', IPOPT_formulation.constr, ...
    'p', IPOPT_formulation.sigma ...
);

solver = nlpsol('solver', 'ipopt', nlp, opts_ipopt);

%% Run solver
stats.exit_flag = 1;
stats.elapsed_time = 0;

tic;
sol = CallIPOPTSolver( solver, IPOPT_formulation, 10e-4 );
stats.elapsed_time = solver.stats.t_proc_total;

solution.x = full(sol.x);

stats.compl = full(problem.Phi(solution.x));
stats.obj = full(problem.Obj(solution.x));
solution.stats = stats;
end