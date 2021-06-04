function [solvers] = RunSolvers(problem, solvers, i)

import casadi.*;

%% Generate objective and penalty functions
Obj = Function('obj', {problem.IPOPTForm.x}, {problem.IPOPTForm.obj});
Phi = Function('phi', {problem.IPOPTForm.x}, {problem.IPOPTForm.compl_L'*problem.IPOPTForm.compl_R});

%% Store options
x0 = problem.IPOPTForm.x0;
rho0 = problem.IPOPTForm.initialPenaltyParameter;
beta = 10;

%% Method 1) Solve using IPOPT Penalty
if (isfield(solvers, 'IPOPT_penalty') && solvers.IPOPT_penalty.use)

    % Build penalty solver
    rho = SX.sym('rho',1);
    phi = problem.IPOPTForm.compl_L'*problem.IPOPTForm.compl_R;
    obj_pen = problem.IPOPTForm.obj + rho*phi;
    prob = struct('f', obj_pen, 'x', problem.IPOPTForm.x, 'g', problem.IPOPTForm.constr, 'p', rho);
    solver = nlpsol('solver', 'ipopt', prob , problem.IPOPTForm.opts_ipopt);

    % Initialize loop
    iter = 0;
    time = 0;
    ipopt_comp_viol = inf;
    rho = 0;
    
    % Run solver loop
    while ipopt_comp_viol  > 1e-12 && iter < 100
        tic;

        % Run IPOPT solver
        sol = solver( ...
            'x0', x0, 'lbx', problem.IPOPTForm.lb, 'ubx', problem.IPOPTForm.ub, ...
            'lbg', problem.IPOPTForm.lbA, 'ubg', problem.IPOPTForm.ubA ,'p', rho ...
        );

        % Obtain solutions
        time = time + toc;
        w_opt = full(sol.x);
        x0 = w_opt;
        ipopt_comp_viol = full(Phi(w_opt));

        % If zero pen first, then set to initial pen afterwards
        rho = max(rho0, rho*beta);
        
        % Update number of iterations
        iter = iter + 1;
    end

    solvers.IPOPT_penalty.time_vals(i) = time;
    solvers.IPOPT_penalty.obj_vals(i) = full(Obj(w_opt));
    solvers.IPOPT_penalty.compl_vals(i) = full(Phi(w_opt));
    solvers.IPOPT_penalty.penalty_updates(i) = iter;
    solvers.IPOPT_penalty.iter_total(i) = iter;
    solvers.IPOPT_penalty.exit_flag(i) = ~solver.stats.success;
end

%% FOR ALL LCQP methods
params.solveZeroPenaltyFirst = true;
params.initialPenaltyParameter = rho0;
params.x0 = x0;
params.printLevel = 0;
Q = problem.LCQP_std_form.Q;
g = problem.LCQP_std_form.g;
L = problem.LCQP_std_form.L;
R = problem.LCQP_std_form.R;
A = problem.LCQP_std_form.A;
lbA = problem.LCQP_std_form.lbA;
ubA = problem.LCQP_std_form.ubA;
lb = problem.LCQP_std_form.lb;
ub = problem.LCQP_std_form.ub;

%% Method 2) Solve using LCQP Dense
if (isfield(solvers, 'LCQPanther_qpOSAES_dense') && solvers.LCQPanther_qpOSAES_dense.use)
    params.qpSolver = 0;

    tic;
    [w_opt, ~, stats] = LCQPanther(Q, g, L, R, A, lbA, ubA, lb, ub, params);
    solvers.LCQPanther_qpOSAES_dense.time_vals(i) = toc;
    solvers.LCQPanther_qpOSAES_dense.obj_vals(i) = full(Obj(w_opt));
    solvers.LCQPanther_qpOSAES_dense.compl_vals(i) = full(Phi(w_opt));
    solvers.LCQPanther_qpOSAES_dense.penalty_updates(i) = stats.iters_outer;
    solvers.LCQPanther_qpOSAES_dense.iter_total(i) = stats.iters_total;
    solvers.LCQPanther_qpOSAES_dense.exit_flag(i) = stats.exit_flag;
end

%% Method 3) Solve using LCQP Sparse
if (isfield(solvers, 'LCQPanther_qpOSAES') && solvers.LCQPanther_qpOSAES.use)
    params.qpSolver = 1;
    tic;
    [w_opt, ~, stats] = LCQPanther(sparse(Q), g, sparse(L), sparse(R), sparse(A), lbA, ubA, lb, ub, params);
    solvers.LCQPanther_qpOSAES.time_vals(i) = toc;
    solvers.LCQPanther_qpOSAES.obj_vals(i) = full(Obj(w_opt));
    solvers.LCQPanther_qpOSAES.compl_vals(i) = full(Phi(w_opt));
    solvers.LCQPanther_qpOSAES.penalty_updates(i) = stats.iters_outer;
    solvers.LCQPanther_qpOSAES.iter_total(i) = stats.iters_total;
    solvers.LCQPanther_qpOSAES.exit_flag(i) = stats.exit_flag;
end

%% Method 4) Solve using LCQP OSQP
if (isfield(solvers, 'LCQPanther_OSQP') && solvers.LCQPanther_OSQP.use)
    params.qpSolver = 2;

    % OSQP does not handle box constraints
    if ((~isempty(lb) && ~all(lb == -inf)) || (~isempty(ub) && ~all(ub == inf)))
        A = [A; eye(size(Q))];
        lbA = [lbA; lb];
        ubA = [ubA; ub];
    end

    tic;
    [w_opt, ~, stats] = LCQPanther(sparse(Q), g, sparse(L), sparse(R), sparse(A), lbA, ubA, params);
    solvers.LCQPanther_OSQP.time_vals(i) = toc;
    solvers.LCQPanther_OSQP.obj_vals(i) = full(Obj(w_opt));
    solvers.LCQPanther_OSQP.compl_vals(i) = full(Phi(w_opt));
    solvers.LCQPanther_OSQP.penalty_updates(i) = stats.iters_outer;
    solvers.LCQPanther_OSQP.iter_total(i) = stats.iters_total;
    solvers.LCQPanther_OSQP.exit_flag(i) = stats.exit_flag;
end

%% Method 5) Solve using LCQP MATLAB
if (isfield(solvers, 'LCQP_matlab') && solvers.LCQP_matlab.use)
    params.qpSolver = 0;

    tic;
    [w_opt, ~,~,~, exitflag, ~, iter, k] = LCQP(sparse(Q), g, L, sparse(R), sparse(A), lbA, ubA, lb, ub, params);
    solvers.LCQP_matlab.time_vals(i) = toc;
    solvers.LCQP_matlab.obj_vals(i) = full(Obj(w_opt));
    solvers.LCQP_matlab.compl_vals(i) = full(Phi(w_opt));
    solvers.LCQP_matlab.penalty_updates(i) = k;
    solvers.LCQP_matlab.iter_total(i) = iter;
    solvers.LCQP_matlab.exit_flag(i) = exitflag;
end

end