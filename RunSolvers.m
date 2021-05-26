function [] = RunSolvers(problem_name, Q, g, L, R, A, lbA, ubA, lb, ub, params)

% Solve zero penalty first: default option is true
if (~isfield(params, 'solveZeroPenaltyFirst') || params.solveZeroPenaltyFirst)
    rho = 0;
else
    rho = params.initialPenaltyParameter;
end

% Update factor
beta = params.penaltyUpdateFactor;

%% Generate objective and penalty functions
obj = @(x) 1/2*x'*Q*x + g'*x;
phi = @(x) x'*L'*R*x;

%% Method 1) Solve using IPOPT Penalty
IPOPTStruct = GenerateIPOPTSolver(Q, g, L, R, A, lbA, ubA);

iter = 0;
time = 0;
ipopt_comp_viol = inf;
x0 = params.x0;
while ipopt_comp_viol  > 1e-12 && iter < 100
    iter = iter + 1;
    tic;
    
    % Run IPOPT solver
    sol = IPOPTStruct.Solver( ...
        'x0', x0, 'lbx', lb, 'ubx', ub, ...
        'lbg', IPOPTStruct.lbA, 'ubg', IPOPTStruct.ubA ,'p', rho ...
    );
    
    % Obtain solutions
    time = time + toc;
    w_opt = full(sol.x);
    x0 = w_opt;
    ipopt_comp_viol = phi(w_opt);
    
    % If zero pen first, then set to initial pen afterwards
    rho = max(params.initialPenaltyParameter, rho*beta);
end

ipopt_pen_solver.time_vals = time;
ipopt_pen_solver.obj_vals = obj(w_opt);
ipopt_pen_solver.compl_vals = phi(w_opt);
ipopt_pen_solver.w_opt = w_opt;
ipopt_pen_solver.iter = iter;
ipopt_pen_solver.exit_flag = ~IPOPTStruct.Solver.stats.success;

%% Method 2) Solve using LCQP Dense
params.qpSolver = 0;
params.printLevel = 2;
tic;
[w_opt, ~, stats] = LCQPanther(Q, g, L, R, A, lbA, ubA, lb, ub, params);
lcqp_dense.time_vals = toc;
lcqp_dense.obj_vals = obj(w_opt);
lcqp_dense.compl_vals = phi(w_opt);
lcqp_dense.w_opt = w_opt;
lcqp_dense.stats = stats;
lcqp_dense.iter = stats.iters_total;
lcqp_dense.exit_flag = stats.exit_flag;

%% Method 3) Solve using LCQP Sparse
params.qpSolver = 1;
tic;
[w_opt, ~, stats] = LCQPanther(sparse(Q), g, sparse(L), sparse(R), sparse(A), lbA, ubA, lb, ub, params);
lcqp_sparse.time_vals = toc;
lcqp_sparse.obj_vals = obj(w_opt);
lcqp_sparse.compl_vals = phi(w_opt);
lcqp_sparse.w_opt = w_opt;
lcqp_sparse.stats = stats;
lcqp_sparse.iter = stats.iters_total;
lcqp_sparse.exit_flag = stats.exit_flag;

%% Save plot maps
solution_map = containers.Map;
solution_map("IPOPT Penalty") = ipopt_pen_solver;
solution_map("LCQP Dense") = lcqp_dense;
solution_map("LCQP Sparse") = lcqp_sparse;

if ~exist('saved_variables', 'dir')
   mkdir('saved_variables')
end

outfile = ['saved_variables/', problem_name, '.mat'];

fprintf("Saving to file %s\n", outfile);
save(outfile, 'solution_map');
end