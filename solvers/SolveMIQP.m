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

if isfield(MIQP_formulation, "x0")
    model.start = MIQP_formulation.x0;
end

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
params.IntFeasTol = 5e-7;
params.FeasibilityTol = 5e-7;

tic;
results = gurobi(model, params);
solution.stats.elapsed_time_w_overhead = toc;

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

end
