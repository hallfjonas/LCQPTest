function [solution] = SolveIPOPTRegEq(casadi_formulation)

% Import casadi
import casadi.*

%% Get formulation
IPOPT_formulation = ObtainIPOPTRegEq(casadi_formulation);
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

% As far as I know there doesn't exist a similar trick as 0 pen init
sigma = complementaritySettings.sigma0;
stats.iters_outer = 0;

tic;
while(sigma > complementaritySettings.sigmaMin)
        
    % Call solver again    
    sol = CallIPOPTSolver(solver, IPOPT_formulation, sigma);
    w_opt = sol.x;
    
    % Update initial guess to previous solution
    IPOPT_formulation.x0 = w_opt;

    stats.elapsed_time = stats.elapsed_time + solver.stats.t_proc_total;
    stats.iters_outer = stats.iters_outer + 1;
    
    if (abs(full(casadi_formulation.Phi(w_opt))) < complementaritySettings.complementarityTolerance)
        stats.exit_flag = 0;
        break
    end
    
    sigma = sigma*complementaritySettings.betaSigma;
end

stats.elapsed_time_w_overhead = toc;
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