function [ problem ] = GetMovingMassesLCQP(nMasses, T, N)

addpath("~/casadi-matlab2014b-v3.5.5");
import casadi.*

% Step size and number of nodes
h = T/N;

% Terminal constraint tolerance
tol = 0;

%% Create the discretized QP with LCP constraints
collocation_times   % here select degre d, and scheme radau or legendre

% State variables
p = SX.sym('p', nMasses,1);       % Position
v = SX.sym('v', nMasses,1);       % Velocity

% Algebraic variables
y = SX.sym('y', nMasses, 1);               % Switching values
lambda0 = SX.sym('lambda0', nMasses, 1);   % Refering to negative parts of v
lambda1 = SX.sym('lambda1', nMasses, 1);   % Refering to positive parts of v

% Combined
x = [p; v];                             % states
z = [y; lambda0; lambda1];              % algebraic states
u = SX.sym('u', 1);                     % controls

%% Dynamics                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
% variable dimensions
nx = length(x);
nz = length(z);
nu = length(u);

% Build ODE
f_x = [];

% pdot = v
for i = 1:nMasses
    f_x = [f_x; v(i)]; 
end
    
% vdot = ... 
f_x = [f_x; -2*p(1) + p(2) - v(1) + 0.3*(1 - 2*y(1))];
for i=2:nMasses-1
    f_x = [f_x; p(i-1) - 2*p(i) + p(i+1) - v(i) + 0.3*(1 - 2*y(i))];
end
% Last mass has control
f_x = [f_x; p(nMasses-1) - 2*p(nMasses) - v(nMasses) + 0.3*(1 - 2*y(nMasses)) + u];

% Objective
f_q = x(1:2*nMasses)'*x(1:2*nMasses) + u'*u;

% Regularization: Binary variables around 0.5
reg_fact = 1e-8;
f_q = f_q + reg_fact*((y-0.5)'*(y-0.5) + lambda0'*lambda0 + lambda1'*lambda1);

% algebraic equations
f_z = v - (lambda0  - lambda1);

% RHS of ODE in the DAE
ode_and_cost = Function('f_x',{x, u, z},{f_x, f_q, f_z});      


%% Start with an empty NLP
% Objective
J = 0;

% Optimization variables
w={};
w0 = [];
lbw = [];
ubw = [];

% Linear Constraints
g={};
lbg = [];
ubg = [];

% Complementarity Constraints
compl_L = {};
compl_R = {};

% Fixed initial positions and velocities in [-1, 1]
if (nMasses == 2)
    p0 = [-1; 1];
    v0 = [1; -1];
elseif (nMasses == 3)
    p0 = [1; -1; 0];
    v0 = [1; 0; -1];
end
x0 = [p0; v0];

% "Lift" initial conditions
Xk = SX.sym('Xk', nx);
w = {w{:}, Xk};

% Fix initial conditions
lbw = [lbw; x0];
ubw = [ubw; x0];

% Regularization on initial condition
J = J + (Xk - x0)'*(Xk - x0);

% initial guess
w0 = [w0; x0];

% Keeping track of indices in order to be able to extract them later
ind_x = 1:nx;
ind_u = [];
ind_z = [];
ind_total = [ind_x];

% Initial guess for algebraic states
y0 = 0.5*ones(size(y));
lam0 = zeros(size(lambda0));
lam1 = zeros(size(lambda1));
z0 = [y0; lam0; lam1];

% Box constraints on x, z, and u
lb_x = -inf(nx, 1);
ub_x = inf(nx, 1);
lb_z  = -inf(nz, 1);            % non-neg. is imposed by solver
ub_z = inf(nz, 1);              % non-neg. is imposed by solver
lb_u = -inf(nu,1);
ub_u = inf(nu,1);

%% Formulate the NLP
for k=0:N-1
    Uk = SX.sym(['U_' num2str(k)],nu);

    % Add control to optimization variables
    w = {w{:}, Uk};

    % Add u to indices        
    ind_u = [ind_u,ind_total(end)+1:ind_total(end)+nu];
    ind_total  = [ind_total,ind_total(end)+1:ind_total(end)+nu];

    % Add box constraints to control 
    lbw = [lbw; lb_u];
    ubw = [ubw; ub_u];

    % Construct initial guess
    w0 = [w0; zeros(nu,1)];
    
    Xkj = SX.sym(['X', num2str(k)], nx);
    Zkj = SX.sym(['Z', num2str(k)], nz);

    w = {w{:}, Xkj, Zkj};

    % box constraints for algebraic variables.
    lbw = [lbw; lb_x; lb_z];
    ubw = [ubw; ub_x; ub_z];
    w0 = [w0; x0; z0];

    % Update state indices
    newStates = ind_total(end)+1:ind_total(end)+nx; 
    ind_x = [ind_x, newStates];
    ind_total  = [ind_total, newStates];

    % Update algebraic state indices
    newComplementarities = ind_total(end)+1:ind_total(end)+nz;        
    ind_z = [ind_z, newComplementarities];
    ind_total  = [ind_total,newComplementarities];

    % Append to complementariy functions:
    % comp: 0 <=     y _|_ lambda1 >= 0
    %       0 <= 1 - y _|_ lambda0 >= 0
    Ykj = Zkj(1:nMasses);
    Lambda0kj = Zkj(nMasses+1:2*nMasses);
    Lambda1kj = Zkj(2*nMasses+1:3*nMasses);
    compl_L = {compl_L{:}, Ykj, (1 - Ykj)};
    compl_R = {compl_R{:}, Lambda1kj, Lambda0kj};
    
    % Collocation equation
    Xk_end = D(1)*Xk;
    xp = C(1,2)*Xk + C(2,2)*Xkj;
        
    % ODE and objective
    [fj, qj, fz] = ode_and_cost(Xkj, Uk, Zkj);
    
    % collect discretized DAE equations
    g = {g{:}, h*fj - xp};
    lbg = [lbg; zeros(nx,1)];
    ubg = [ubg; zeros(nx,1)];
    
    g = {g{:}, fz};
    lbg = [lbg; zeros(size(fz))];
    ubg = [ubg; zeros(size(fz))];

    % Add contribution to the end state
    Xk_end = Xk_end + D(2)*Xkj;

    % Add contribution to quadrature function
    J = J + qj*h;
    
    % Keep track of this node for next node
    Xk = Xk_end;
end

% Terminal constraint
g = {g{:}, Xkj(1:2*nMasses)};
lbg = [lbg; -tol*ones(2*nMasses,1)];
ubg = [ubg; tol*ones(2*nMasses,1)];
    
%% Build a forward simulation initial guess
forward_sim = BuildInitialGuess(ode_and_cost, x0, zeros(nu,1), nz, h, N, nMasses, false);

%% Capture the LCQP
% Name classification
% States and box constraints
problem.x = vertcat(w{:});
problem.x0 = forward_sim;
problem.lb = lbw;
problem.ub = ubw;

% Objective
problem.obj = J;

% Linear constraints and bounds
problem.constr = vertcat(g{:});
problem.lb_constr = lbg;
problem.ub_constr = ubg;

% Complementarity pairs
problem.compl_L = vertcat(compl_L{:});
problem.compl_R = vertcat(compl_R{:});

% Indices
problem.indices_x = ind_x;
problem.indices_u = ind_u;
problem.indices_z = ind_z;

% Problem functions (for comparing solutions)
problem.Obj = Function('Obj', {problem.x}, {problem.obj});
Compl_L = Function('Compl_L', {problem.x}, {problem.compl_L});
Compl_R = Function('Compl_R', {problem.x}, {problem.compl_R});
problem.Phi = Function('Phi', {problem.x}, {Compl_L(problem.x)'*Compl_R(problem.x)});

% Problem dimension
problem.n_x = length(problem.x);
problem.n_c = length(problem.constr);
problem.n_comp = length(problem.compl_L);

end