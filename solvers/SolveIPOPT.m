function [solutions] = SolveIPOPT(problem)

import casadi.*
addpath("~/LCQPow/build/lib");

%% Get formulation
IPOPT_formulation = ObtainIPOPTPen(problem.casadi_formulation);

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
stats.elapsed_time = stats.elapsed_time + toc;

w_opt = sol.x;

rho = IPOPT_formulation.rho0;
stats.iters_outer = 0;
while(rho < IPOPT_formulation.rhoMax)  
        
    tic;
    sol = CallIPOPTSolver(solver, IPOPT_formulation, rho);
    stats.elapsed_time = stats.elapsed_time + toc;
    
    w_opt = sol.x;
    stats.iters_outer = stats.iters_outer + 1;
    
    if (abs(full(problem.casadi_formulation.Phi(w_opt))) < problem.casadi_formulation.complementarityTolerance)
        stats.exit_flag = 0;
        break
    end

    rho = rho*IPOPT_formulation.beta;
end

stats.rho_opt = rho;
solutions.x = full(sol.x);
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));
solutions.stats = stats;

end