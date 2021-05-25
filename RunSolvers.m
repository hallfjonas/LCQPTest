function [] = RunSolvers(problem_name, Q, g, L, R, A, lbA, ubA, lb, ub, params)

rho = params.initialPenaltyParameter;
beta = params.penaltyUpdateFactor;

%% Generate objective and penalty functions
obj = @(x) 1/2*x'*Q*x + g'*x;
phi = @(x) x'*L'*R*x;

%% Method 1) Solve using IPOPT Penalty
IPOPTStruct = GenerateIPOPTSolver(Q, g, L, R, A, lbA, ubA, lb, ub);

iter = 1;
ipopt_comp_viol = inf;
x0 = params.x0;
while ipopt_comp_viol  > 1e-12 && iter < 10
    tic;
    sol = IPOPTStruct.Solver( ...
        'x0', x0, 'lbx', lb, 'ubx', ub, ...
        'lbg', lbA, 'ubg', ubA ,'p', rho ...
    );
    time = time + toc;
    w_opt = full(sol.x);
    x0 = w_opt;
    ipopt_comp_viol = phi(w_opt);
    iter = iter +1;
    rho = rho*beta;
end

ipopt_pen_solver.time_vals = time;
ipopt_pen_solver.obj_vals = obj(w_opt);
ipopt_pen_solver.compl_vals = ipopt_comp_viol;
ipopt_pen_solver.w_opt = w_opt;

%% Method 2) Solve using LCQP
tic;
w_opt = LCQPanther(Q, g, L, R, A, lbA, ubA, lb, ub, params);
lcqp_solver.time_vals = toc;
lcqp_solver.obj_vals = obj(w_opt);
lcqp_solver.compl_vals = ipopt_comp_viol;
lcqp_solver.w_opt = w_opt;

%% Save plot maps
solution_map = containers.Map;
solution_map("IPOPT Penalty") = ipopt_pen_solver;
solution_map("LCQP") = lcqp_solver;

if ~exist('saved_variables', 'dir')
   mkdir('saved_variables')
end

outfile = ['saved_variables/', problem_name];
save(outfile, solution_map);
end