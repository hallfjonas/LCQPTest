
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

M = 10e3;
lb_L = zeros(nComp,1);
ub_L = M*ones(nComp,1);
lb_R = zeros(nComp,1);
ub_R = M*ones(nComp,1);

if (isfield(lcqp_formulation, "lb_L"))
    lb_L = lcqp_formulation.lb_L;
end
if (isfield(lcqp_formulation, "ub_L"))
    ub_L = lcqp_formulation.ub_L;
end

if (isfield(lcqp_formulation, "lb_R"))
    lb_R = lcqp_formulation.lb_R;
end
if (isfield(lcqp_formulation, "ub_R"))
    ub_R = lcqp_formulation.ub_R;
end

%% Now introduce binary variables and extend to that diemnsion
% obj
Q_new = sparse([Q, zeros(nV,2*nComp); zeros(2*nComp,nV), zeros(2*nComp,2*nComp)]);
g_new = [g; zeros(2*nComp,1)];
problem.Q = Q_new;
problem.g = g_new;

% constraints
A_new = [A, zeros(nC,2*nComp)];
L_new = [L, zeros(nComp,2*nComp)];
R_new = [R, zeros(nComp,2*nComp)];

% Lx - ub_L*z <= 0
A_comp_L = [L, - ub_L.*eye(nComp), zeros(nComp,nComp)];
A_comp_R = [R, zeros(nComp,nComp), - ub_R.*eye(nComp)];
A_bin = [zeros(nComp, nV), eye(nComp), eye(nComp)];

problem.L = L_new;
problem.R = R_new;
problem.lb_L = lb_L;
problem.lb_R = lb_R;
A = [A_new; -A_new; L_new; -L_new; R_new; -R_new; A_comp_L; A_comp_R; A_bin];
rhs = [ubA; -lbA; ub_L; -lb_L; ub_R; -lb_R; zeros(nComp,1); zeros(nComp,1); ones(nComp,1)];

% Have box constraints?
if ~isempty(lb) 
    E = eye(nV);
    for i=1:length(lb)
        if (lb(i) >  -inf)
            A = [A; -E(i,:), zeros(1, 2*nComp)];
            rhs = [rhs; -lb(i)];
        end
    end
end
if ~isempty(ub)
    E = eye(nV);
    for i=1:length(ub)
        if (ub(i) <inf)
            A = [A; E(i,:), zeros(1, 2*nComp)];
            rhs = [rhs; ub(i)];
        end
    end
end

problem.A = sparse(A);
problem.rhs = rhs;

return
