function [solution] = SolveMIQP(casadi_formulation)

import casadi.*;

%% Create the LCQP
problem = ObtainLCQPFromCasadi(casadi_formulation, 0);

%% Change to MIQP setting
MIQP_formulation = ObtainMIQP(problem);

%% Build solver
varnames = {};
nV = MIQP_formulation.nV;
nC = MIQP_formulation.nC;
nComp = MIQP_formulation.nComp;
for i=1:nV
    varnames{i} = ['x', num2str(i)];
end
for i=1:nComp
    varnames{nV+i} = ['zL', num2str(i)];
end
for i=1:nComp
    varnames{nV+nComp+i} = ['zR', num2str(i)];
end
model.varnames = varnames;

model.Q = MIQP_formulation.Q;
model.obj = MIQP_formulation.g;

model.A = MIQP_formulation.A;
model.rhs = MIQP_formulation.rhs;
model.sense = '<';
model.lb = MIQP_formulation.lb;
model.ub = MIQP_formulation.ub;
 
% Set variable types
for i=1:nV
    model.vtype(i) = 'C';
end
for i=1:nComp
    model.vtype(nV+i) = 'B';
    model.vtype(nV+nComp+i) = 'B';
end

%% Run the solver
params.outputflag = 0; 
params.IntFeasTol = 1e-9;
results = gurobi(model, params);

% Save the solution and stats
solution.stats.elapsed_time = results.runtime;
solution.stats.exit_flag = 1 - strcmp(results.status, 'OPTIMAL');
solution.x = zeros(nV+2*nComp,1);
solution.stats.compl = inf;
solution.stats.obj = inf;

% Evaluate complementarity
if solution.stats.exit_flag == 0
    compl_L = MIQP_formulation.L*results.x - MIQP_formulation.lb_L;
    compl_R = MIQP_formulation.R*results.x - MIQP_formulation.lb_R;
    compl = compl_L'*compl_R;
    solution.x = results.x;
    solution.stats.compl = compl;
    solution.stats.obj = full(problem.Obj(solution.x(1:nV)));
end


%% Sanity check plot
% x_vals = solution.x(casadi_formulation.indices_x);
% y_vals = [nan; solution.x(casadi_formulation.indices_z(1:2:end))];
% lam_vals = [nan; solution.x(casadi_formulation.indices_z(2:2:end))];
% z_L_vals = solution.x(end-2*nComp+1:end-nComp);
% z_R_vals = solution.x(end-nComp+1:end);
% t_vals = linspace(0, 2, length(x_vals));
% figure(1); grid on; hold on;
% plot(t_vals, x_vals, "Color", "black");
% plot(t_vals, y_vals, "Color", "blue");
% plot(t_vals, lam_vals, "Color", "yellow");
% plot(t_vals, x_vals + lam_vals, "Color", "green");

%figure(2); grid on; hold on;
% [Green z_L = 0 => y = 0]
% [Red   z_R = 0 => lambda = 0]
%plot(t_vals, [nan; z_L_vals(1:2:end)], "Color", "green", "LineStyle","-", "LineWidth", 2);
%plot(t_vals, [nan; z_R_vals(1:2:end)], "Color", "red", "LineStyle","--", "LineWidth", 2);
%plot(t_vals, lam_vals, "Color", "yellow");

% figure(3); grid on; hold on;
% [Green z_L = 0 => y = 1]
% [Red   z_R = 0 => x + lambda = 0]
% plot(t_vals, [nan; z_L_vals(2:2:end)], "Color", "green", "LineStyle","-", "LineWidth", 2);
% plot(t_vals, [nan; z_R_vals(2:2:end)], "Color", "red", "LineStyle","--", "LineWidth", 2);

% plot(t_vals, [nan; z_L_vals(2:2:end) + z_R_vals(2:2:end)], "Color", "magenta", "LineStyle","-.", "LineWidth", 2);
%x_vals

end
