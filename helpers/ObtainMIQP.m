
function [problem] = ObtainMIQP(lcqp_formulation)

%% Extract variables, initial guess and box constraints
Q = 0.5*lcqp_formulation.Q;
nV = size(Q,1);
problem.nV = nV;

lb = [];
ub = [];
if (isfield(lcqp_formulation, "lb"))
    lb = lcqp_formulation.lb;
end

if (isfield(lcqp_formulation, "ub"))
    ub = lcqp_formulation.ub;
end

g = lcqp_formulation.g;

nC = 0;
if (isfield(lcqp_formulation, "A"))
    A = lcqp_formulation.A;
    lbA = lcqp_formulation.lbA;
    ubA = lcqp_formulation.ubA;
    nC = size(A,1);
end
problem.nC = nC;

%% Complementarities
L = lcqp_formulation.L;
R = lcqp_formulation.R;
nComp = size(L,1);
problem.nComp = nComp;

M = 90;
lb_L = zeros(nComp,1);
ub_L = M*ones(nComp,1);
lb_R = zeros(nComp,1);
ub_R = M*ones(nComp,1);

if (isfield(lcqp_formulation, "lbL") && ~isempty(lcqp_formulation.lbL))
    lb_L = lcqp_formulation.lbL;
end

if (isfield(lcqp_formulation, "ubL") && ~isempty(lcqp_formulation.ubL))
    ub_L = lcqp_formulation.ubL;
end

if (isfield(lcqp_formulation, "lbR") && ~isempty(lcqp_formulation.lbR))
    lb_R = lcqp_formulation.lbR;
end

if (isfield(lcqp_formulation, "ubR") && ~isempty(lcqp_formulation.ubR))
    ub_R = lcqp_formulation.ubR;
end

%% Now introduce binary variables and extend to that dimension
% obj
Q_new = sparse([Q, zeros(nV,2*nComp); zeros(2*nComp,nV), zeros(2*nComp,2*nComp)]);
g_new = [g; zeros(2*nComp,1)];
problem.Q = Q_new;
problem.g = g_new;

% constraints
A_new = [A, zeros(nC,2*nComp)];
L_new = [L, zeros(nComp,2*nComp)];
R_new = [R, zeros(nComp,2*nComp)];

% Lx + (lb_L - ub_L)*z <= lb_L
A_comp_L = [L, (lb_L - ub_L).*eye(nComp), zeros(nComp,nComp)];
A_comp_R = [R, zeros(nComp,nComp), (lb_R - ub_R).*eye(nComp)];

% Enforce one lower bound to be active (zL + zR <= 1)
A_bin = [zeros(nComp, nV), eye(nComp), eye(nComp)];

problem.L = L_new;
problem.R = R_new;
problem.lb_L = lb_L;
problem.lb_R = lb_R;
problem.ub_L = ub_L;
problem.ub_R = ub_R;
problem.A = sparse([A_new; -A_new; L_new; -L_new; R_new; -R_new; A_comp_L; A_comp_R; A_bin]);
problem.rhs = [ubA; -lbA; ub_L; -lb_L; ub_R; -lb_R; lb_L; lb_R; ones(nComp, 1)];

% Have box constraints?
if ~isempty(lb)
    problem.lb = [lb; -inf(2*nComp, 1)];
else
    problem.lb = -inf(nV+2*nComp, 1);
end

if ~isempty(ub)
    problem.ub = [ub; inf(2*nComp,1)];
else
    problem.ub = inf(nV+2*nComp, 1);
end

% Have initial guess?
if isfield(lcqp_formulation, "x0")
    problem.x0 = zeros(size(problem.lb));
    problem.x0(1:nV) = lcqp_formulation.x0;
end


return
