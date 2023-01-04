function [ problem ] = GetIVOCP(T, N, x00)

h = T/N;

% Import casadi
import casadi.*

% Load CasADi collocation matrices
collocation_times;

% State variables
x = SX.sym('x');

% Algebraic variables
y = SX.sym('y');
lambda0 = SX.sym('lambda0');
z = [y,lambda0];

% Regularization factor
regTerm = eps;

% State/Algebraic dimensions
nx = length(x);
nz = length(z);

% State and algebraic state bounds
lb_x = -inf;
ub_x = inf;
lb_z  = [0;0];
ub_z = [1;inf];

% Constraints and objective contributions
f_x = 1*y+3*(1-y);
f_q = x^2;
F = Function('f_x',{x, z},{f_x, f_q});

% Initialize objective expression 
J = 0;

% Initialize variables
w = {};
w0 = [];

% Initialize (box and linear) constraints
g = {};
lbw = [];
ubw = [];
lbg = [];
ubg = [];

% Values for building initial guess 
% (Initial guess of state is adapted later)
x0 = -1;
z0 = [0; 1];

% "Lift" initial conditions
Xk = SX.sym('X0', nx);
w = {w{:}, Xk};

% Add regularization term to lifted variable
J = J + regTerm*(Xk'*Xk);

% Add bounds for lifted variable
lbw = [lbw; -inf];
ubw = [ubw; inf];

% Add initial guess for lifted variable
w0 = [w0; x0];

% Keep track of indices
ind_x = 1:nx;
ind_z = [];
ind_total = ind_x;

% Complementarity Constraints
compl_L = {};
compl_R = {};

%% Formulate the NLP
for k=0:N-1
    % New node
    Xkj = SX.sym(['X_' num2str(k)], nx);
    Zkj = SX.sym(['Z_' num2str(k)], nz);
    w = {w{:}, Xkj, Zkj};

    % box constraints for new node
    lbw = [lbw; lb_x; lb_z];
    ubw = [ubw; ub_x; ub_z];
    
    % initial guess for new node
    w0 = [w0; x0; z0];

    % Update (state) indices
    newStates = ind_total(end)+1:ind_total(end)+nx; 
    ind_x = [ind_x, newStates];
    ind_total  = [ind_total, newStates];

    % Update algebraic state indices
    newComplementarities = ind_total(end)+1:ind_total(end)+nz;        
    ind_z = [ind_z, newComplementarities];
    ind_total  = [ind_total,newComplementarities];

    % Append to complementariy functions:
    % comp: 0 <=     y _|_ lambda- >= 0
    %       0 <= 1 - y _|_ lambda+ >= 0
    Ykj = Zkj(1);
    Lambda0kj = Zkj(2);
    Lambda1kj = Xkj + Lambda0kj;
    compl_L = {compl_L{:}, Ykj, (1 - Ykj)};
    compl_R = {compl_R{:}, Lambda0kj, Lambda1kj};
    
    % Collocation equation
    Xk_end = D(1)*Xk;
    xp = C(1,2)*Xk + C(2,2)*Xkj;
                    
    % ODE and objective
    [fx, fq] = F(Xkj, Zkj);

    % collect discretized DAE equations
    g = {g{:}, h*fx - xp};
    lbg = [lbg; 0];
    ubg = [ubg; 0];

    % Add contribution to the end state
    Xk_end = Xk_end + D(2)*Xkj;

    % Add contribution to quadrature function
    J = J + B(2)*fq*h;

    % Add regularization term to algebraic variables
    J = J + regTerm*(Zkj'*Zkj);

    % Keep track of this node for next node
    Xk = Xk_end;
end

% Terminal cost
J = J + (Xk_end-5/3)^2;

%% Capture the LCQP

x0 = BuildInitialGuessIVOCP(F, x00, nz, h, N); 

% States and box constraints
problem.x = vertcat(w{:});
problem.x0 = x0;
problem.lb = lbw;
problem.ub = ubw;

% Objective
problem.J = J;

% Linear constraints and bounds
problem.constr = vertcat(g{:});
problem.lbA = lbg;
problem.ubA = ubg;

% Complementarity pairs
problem.compl_L = vertcat(compl_L{:});
problem.compl_R = vertcat(compl_R{:});

% Indices
problem.indices_x = ind_x;
problem.indices_z = ind_z;

% Problem dimension
problem.n_x = length(problem.lb);
problem.n_c = length(problem.constr);
problem.n_comp = length(problem.compl_L);
problem.nx = nx;
problem.nz = nz;

% Compute Analytic Solution
x = linspace(-1.9,-0.9,1000);
L = zeros(length(x), 1);
for i = 1:length(x)
    x0 = x(i);
    ts = -x0/3;
    L(i) = (8/3*ts^3 +8/3*x0*ts^2 + 8/9*x0^2*ts +1/3*T^3+1/3*x0*T^2+x0^2*T/9) + (T+(x0-5)/3)^2;
end
[~, ind_min] = min(L);
x0_opt = x(ind_min);

% Problem functions (for comparing solutions)
problem.Obj = Function('Obj', {problem.x}, {J});
problem.DistToSol = Function('DistToSol', {problem.x}, {abs(x(1) - x0_opt)});
Compl_L = Function('Compl_L', {problem.x}, {problem.compl_L});
Compl_R = Function('Compl_R', {problem.x}, {problem.compl_R});
problem.Phi = Function('Phi', {problem.x}, {Compl_L(problem.x)'*Compl_R(problem.x)});

end

