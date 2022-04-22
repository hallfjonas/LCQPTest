function [solution] = SolveMIQP(name)

import casadi.*;

% Remember the name?
problemname = name;

%% Create the LCQP
currdir = pwd;
cd MacMPECMatlab/;
run([name, '.m']);
cd(currdir);

if (~isfield(problem, 'A'))
    problem.A = [];
    problem.lbA = [];
    problem.ubA = [];
end

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

% TODO: Where should I handle sparsity? sparse( )
model.Q = MIQP_formulation.Q;
model.obj = MIQP_formulation.g;

model.A = MIQP_formulation.A;
model.rhs = MIQP_formulation.rhs;
model.sense = '<';

% Set variable types
for i=1:nV
    model.vtype(i) = 'C';
end
for i=1:nComp
    model.vtype(nV+i) = 'B';
    model.vtype(nV+nComp+i) = 'B';
end

if startsWith(problemname, 'ex9_2_4')
    disp("CHECK THIS");
end

%% Run the solver
params.outputflag = 1; 
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
