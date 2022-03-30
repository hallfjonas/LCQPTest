function [solutions] = SolveMIQP(problem)

addpath("~/LICQPow/build/lib");

%% Get formulation
MIQP_formulation = ObtainMIQP(problem.casadi_formulation);

%% Build solver
% names = {'x', 'y', 'z'};
model.varnames = MIQP_formulation.varnames;

% TODO: Where should I handle sparsity? sparse( )
model.Q = MIQP_formulation.Q;
model.obj = MIQP_formulation.g;

model.A = MIQP_formulation.A;
model.rhs = MIQP_formulation.rhs;
model.sense = '>';

gurobi_write(model, 'qp.lp');

stats = {};

%% Run the solver
% TODO: Can I get the solver time from results struct?
tic;
results = gurobi(model);
stats.elapsed_time = toc;

% Save the solution and stats
solutions.x = results.x;
solutions.obj = full(problem.casadi_formulation.Obj(solutions.x));
solutions.compl = full(problem.casadi_formulation.Phi(solutions.x));
solutions.stats = stats;

end