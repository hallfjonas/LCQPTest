function [solution] = SolveIPOPT(name)

import casadi.*

%% Get formulation
run(['MacMPECMatlab/', name, '.m']);
IPOPT_formulation = GetIPOPTFormulation(problem);

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

sol = CallIPOPTSolver( solver, IPOPT_formulation, 0 );
w_opt = sol.x;
stats.elapsed_time = solver.stats.t_proc_total;

rho = IPOPT_formulation.rho0;
stats.iters_outer = 0;
while(true)  
    
    if (abs(full(IPOPT_formulation.Phi(w_opt))) < 1e-10)
        stats.exit_flag = 0;
        break
    end
    
    if (rho > IPOPT_formulation.rhoMax)
        break;
    end
        
    sol = CallIPOPTSolver( solver, IPOPT_formulation, rho );
    w_opt = sol.x;
    
    stats.elapsed_time = stats.elapsed_time + solver.stats.t_proc_total;
    stats.iters_outer = stats.iters_outer + 1;
    
    rho = rho*IPOPT_formulation.beta;
end

solution.x = full(sol.x);

stats.compl = full(IPOPT_formulation.Phi(solution.x));
stats.rho_opt = rho;
stats.obj = full(problem.Obj(solution.x));
solution.stats = stats;

end