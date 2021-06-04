function [form] = IPOPTFormulation(N)
% Build optim on unit circle
%
%   min   (x-xk)'*Q*(x-xk)
%   s.t.   ||x||^2 = 1
%

import casadi.*;

% Optimization variables
nz = 2 + 2*N;
w = SX.sym('w', nz,1);
x = w(1:2);

% Reference point
xk = [0.5; -0.6];

% Objective
Qx = [17 -15; -15 17];
obj = 1/2*(x - xk)'*Qx*(x - xk);
for i = 3:nz
    obj = obj + eps*w(i)*w(i);
end

% Allocate Constraints
constr = {};
compl_L = {};
compl_R = {};
theta_sum = 0;

% Bounds
lbA = ones(N+1, 1);
ubA = lbA;

% Fill constraints
for i = 1:N
    % Equality constraint ([cos sin]'*x + lambda = 1)
    seg = [cos(2*pi*i/N); sin(2*pi*i/N)];
    lambda = w(2 + 2*i - 1);
    constr = {constr{:}, seg'*x + lambda};
    
    % Add contribution to theta sum
    theta = w(2+2*i);
    theta_sum = theta_sum + theta;
    
    % Complementarity constraint
    compl_L = {compl_L{:}, lambda};
    compl_R = {compl_R{:}, theta};
end

% Final constraint
constr = {constr{:}, theta_sum};

% Box constraints (non-negativity on compl. var. and unbounded state var)
lb = zeros(nz,1);
ub = inf(nz,1);
lb(1:2) = -inf(2,1);

% Build simple initial guess
x0 = ones(nz,1);
x0(1:2) = xk;

% IPOPT options
opts_ipopt = [];
opts_ipopt.ipopt.mu_strategy = 'adaptive';
opts_ipopt.ipopt.mu_oracle = 'quality-function';
opts_ipopt.ipopt.max_iter = 1000;
opts_ipopt.ipopt.tol = 10*1e-16;
%opts_ipopt.verbose = false;
%opts_ipopt.ipopt.print_level = 0;
%opts_ipopt.print_time = 0;
%opts_ipopt.print_out = 0;
opts_ipopt.ipopt.fixed_variable_treatment = 'make_constraint';  % relax_bounds

% Build struct
form.opts_ipopt = opts_ipopt;
form.x = w;
form.obj = obj;
form.constr = vertcat(constr{:});
form.compl_L = vertcat(compl_L{:});
form.compl_R = vertcat(compl_R{:});
form.lb = lb;
form.ub = ub;
form.lbA = lbA;
form.ubA = ubA;

% Problem specific stuff (not specific to IPOPT)
form.x0 = x0;
form.N = N;
form.initialPenaltyParameter = 0.01;
form.name = ['UnitCircleOptimization'];

end