function [solution] = SolveIPOPTPen(casadi_formulation)

import casadi.*

%% Get formulation
IPOPT_formulation = ObtainIPOPTPen(casadi_formulation);
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
stats.exit_flag = 1;
stats.elapsed_time = 0;

tic;
sol = CallIPOPTSolver( solver, IPOPT_formulation, 0 );
w_opt = sol.x;
stats.elapsed_time = solver.stats.t_proc_total;

rho = complementaritySettings.rho0;
stats.iters_outer = 0;
while(true)  
    
    if (abs(full(casadi_formulation.Phi(w_opt))) < complementaritySettings.complementarityTolerance)
        stats.exit_flag = 0;
        break
    end
    
    if (rho > complementaritySettings.rhoMax)
        break;
    end

    % Update initial guess to previous solution
    IPOPT_formulation.x0 = w_opt;

    % Call solver again
    sol = CallIPOPTSolver( solver, IPOPT_formulation, rho );
    w_opt = sol.x;
    
    stats.elapsed_time = stats.elapsed_time + solver.stats.t_proc_total;
    stats.iters_outer = stats.iters_outer + 1;
    
    rho = rho*complementaritySettings.beta;
end

stats.elapsed_time_w_overhead = toc;

solution.x = full(sol.x);

stats.compl = full(casadi_formulation.Phi(solution.x));
stats.rho_opt = rho;
stats.obj = full(casadi_formulation.Obj(solution.x));
solution.stats = stats;

%% Sanity check plot
% x_vals = solution.x(casadi_formulation.indices_x);
% t_vals = linspace(0, 2, length(x_vals));
% plot(t_vals, x_vals);

end