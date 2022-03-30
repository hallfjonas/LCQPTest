function [solutions] = SolveMIQP(name)

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

if (~exist('lb'))
    lb = [];
end

if (~exist('ub'))
    ub = [];
end

problem.lb = lb;
problem.ub = ub;

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

gurobi_write(model, 'qp.lp');

% Set variable types
for i=1:nV
    model.vtype(i) = 'C';
end
for i=1:nComp
    model.vtype(nV+i) = 'B';
    model.vtype(nV+nComp+i) = 'B';
end

stats = {};

if strcmp(problemname, 'jr1')
    disp("CHECK THIS");
end

%% Run the solver
% TODO: Can I get the solver time from results struct?
params.outputflag = 1; 
tic
results = gurobi(model, params);
solutions.stats.elapsed_time = toc;
% Evaluate objective

import casadi.*
if (exist('w'))
    Obj = Function('Obj', {w}, {obj});
else
    Q = MIQP_formulation.Q(1:nV,1:nV);
    g = MIQP_formulation.g(1:nV,1);
    Obj = @(x) 0.5*x'*Q*x + g'*x;
end

% Save the solution and stats
% solutions.stats.elapsed_time = results.runtime;
solutions.stats.exit_flag = 1 - strcmp(results.status, 'OPTIMAL');

solutions.x = zeros(nV+2*nComp,1);
solutions.stats.compl = inf;
solutions.stats.obj = inf;

% Evaluate complementarity
if solutions.stats.exit_flag == 0
    compl_L = MIQP_formulation.L*results.x - MIQP_formulation.lb_L;
    compl_R = MIQP_formulation.R*results.x - MIQP_formulation.lb_R;
    compl = compl_L'*compl_R;
    solutions.x = results.x;
    solutions.stats.compl = compl;
    solutions.stats.obj = full(Obj(solutions.x(1:nV)));
end