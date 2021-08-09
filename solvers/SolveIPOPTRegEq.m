function [solutions] = SolveIPOPTRegEq(problem)

import casadi.*
addpath("~/LCQPow/build/lib");

%% Get formulation
IPOPT_formulation = ObtainIPOPTRegEq(problem.casadi_formulation);

%% Create NLP solver
opts_ipopt = struct;
opts_ipopt.ipopt.nlp_scaling_method = 'none';
opts_ipopt.ipopt.print_level = 0;
opts_ipopt.ipopt.bound_relax_factor = eps;
opts_ipopt.print_time = 0;
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
sol = CallIPOPTSolver(solver, IPOPT_formulation, 0);
w_opt = sol.x;
stats.elapsed_time = stats.elapsed_time + toc;

sigma = problem.casadi_formulation.sigma0;
stats.iters_outer = 0;

ncomp = problem.casadi_formulation.n_comp;

while(sigma > problem.casadi_formulation.complementarityTolerance/ncomp)
        
    tic;
    sol = CallIPOPTSolver(solver, IPOPT_formulation, sigma);
    w_opt = sol.x;
    
    stats.elapsed_time = stats.elapsed_time + toc;
    stats.iters_outer = stats.iters_outer + 1;
    
    if (abs(full(problem.casadi_formulation.Phi(w_opt))) < problem.casadi_formulation.complementarityTolerance)
        stats.exit_flag = 0;
        break
    end
    
    sigma = sigma*problem.casadi_formulation.betaSigma;
end

stats.rho_opt = sigma;
solutions.x = full(sol.x);
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));
solutions.stats = stats;

end