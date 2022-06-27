function [solution] = SolveIPOPT(problem)

import casadi.*

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

casadi_formulation = problem.casadi_formulation;
nlp = struct(...
    'f', casadi_formulation.obj, ...
    'x', casadi_formulation.x, ...
    'g', casadi_formulation.constr, ...
    'p', casadi_formulation.rho ...
);

solver = nlpsol('solver', 'ipopt', nlp, opts_ipopt);

%% Run solver
stats.exit_flag = 1;
stats.elapsed_time = 0;

sol = CallIPOPTSolver( solver, casadi_formulation, 0 );
w_opt = sol.x;
stats.elapsed_time = solver.stats.t_proc_total;

rho = casadi_formulation.rho0;
stats.iters_outer = 0;
while(true)  
    
    if (abs(full(casadi_formulation.Phi(w_opt))) < 1e-10)
        stats.exit_flag = 0;
        break
    end
    
    if (rho > casadi_formulation.rhoMax)
        break;
    end
        
    sol = CallIPOPTSolver( solver, casadi_formulation, rho );
    w_opt = sol.x;
    
    stats.elapsed_time = stats.elapsed_time + solver.stats.t_proc_total;
    stats.iters_outer = stats.iters_outer + 1;
    
    rho = rho*casadi_formulation.beta;
end

solution.x = full(sol.x);

stats.compl = full(casadi_formulation.Phi(solution.x));
stats.rho_opt = rho;
stats.obj = full(casadi_formulation.Obj(solution.x));
solution.stats = stats;

end