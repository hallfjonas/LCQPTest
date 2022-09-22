function [solution] = SolveIPOPTNLP(casadi_formulation)

import casadi.*

%% Get formulation
IPOPT_formulation = ObtainIPOPTNLP(casadi_formulation);
complementaritySettings = GetComplementaritySettings();

%% Create NLP solver
opts_ipopt = GetIPOPTOptions();

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
sol = CallIPOPTSolver( solver, IPOPT_formulation, complementaritySettings.complementarityTolerance*0.95 );
stats.elapsed_time_w_overhead = toc;

stats.elapsed_time = solver.stats.t_proc_total;

solution.x = full(sol.x);

stats.compl = full(casadi_formulation.Phi(solution.x));
stats.obj = full(casadi_formulation.Obj(solution.x));
stats.exit_flag = stats.compl > complementaritySettings.complementarityTolerance;
solution.stats = stats;

%% Sanity check plot
% x_vals = solution.x(casadi_formulation.indices_x);
% t_vals = linspace(0, 2, length(x_vals));
% plot(t_vals, x_vals);
end