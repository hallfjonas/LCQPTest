function [solution] = SolveIPOPTNLP(casadi_formulation)

import casadi.*

%% Get formulation
IPOPT_formulation = ObtainIPOPTNLP(casadi_formulation);

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
stats.exit_flag = 0;
stats.elapsed_time = 0;

tic;
sol = CallIPOPTSolver( solver, IPOPT_formulation, casadi_formulation.complementarityTolerance*0.95 );
stats.elapsed_time = solver.stats.t_proc_total;

solution.x = full(sol.x);

stats.compl = full(casadi_formulation.Phi(solution.x));
stats.obj = full(casadi_formulation.Obj(solution.x));
stats.exit_flag = stats.compl > casadi_formulation.complementarityTolerance;
solution.stats = stats;

%% Sanity check plot
% x_vals = solution.x(casadi_formulation.indices_x);
% t_vals = linspace(0, 2, length(x_vals));
% plot(t_vals, x_vals);
end