function [solution] = SolveIPOPTReg(casadi_formulation)

import casadi.*
addpath("~/LCQPow/build/lib");

%% Get formulation
IPOPT_formulation = ObtainIPOPTReg(casadi_formulation);

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

% Initialize with inf penalty parameter (similar to 0 penalty)
sol = CallIPOPTSolver(solver, IPOPT_formulation, 10^3);
w_opt = sol.x;

sigma = casadi_formulation.sigma0;
stats.iters_outer = 0;

while(sigma > 1e-17)

    % Update initial guess to previous solution
    IPOPT_formulation.x0 = w_opt;

    % Call solver again
    sol = CallIPOPTSolver(solver, IPOPT_formulation, sigma);
    w_opt = sol.x;
    
    stats.elapsed_time = stats.elapsed_time + solver.stats.t_proc_total;
    stats.iters_outer = stats.iters_outer + 1;
    
    if (abs(full(casadi_formulation.Phi(w_opt))) < casadi_formulation.complementarityTolerance)
        stats.exit_flag = 0;
        break
    end

    sigma = sigma*casadi_formulation.betaSigma;
end

stats.rho_opt = sigma;
solution.x = full(sol.x);
solution.stats = stats;
solution.stats.obj = full(casadi_formulation.Obj(solution.x));
solution.stats.compl = full(casadi_formulation.Phi(solution.x));


%% Sanity check plot
% x_vals = solution.x(casadi_formulation.indices_x);
% t_vals = linspace(0, 2, length(x_vals));
% plot(t_vals, x_vals);

end