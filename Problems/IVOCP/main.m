%% Build Initial Value Problem
N = 75;

%% Prepare LCQP
% Import casadi
import casadi.*

% Time horizon and step length
T = 2;
h = T/N;

% Load CasADi collocation matrices
collocation_times;

% State variables
x = MX.sym('x');

% Algebraic variables
y = MX.sym('y');
lambda0 = MX.sym('lambda0');
l = MX.sym('l');
z = [y,lambda0,l];

% Relaxation parameter
sigma = MX.sym('sigma');

% Regularization factor
regTerm = eps;

% State/Algebraic dimensions
nx = length(x);
nz = length(z);

% State and algebraic state bounds
lb_x = -inf;
ub_x = inf;
lb_z  = [0;0;0];
ub_z = [1;inf;1];

% Constraints and objective contributions
f_x = 1*y+3*l;
f_q = x^2;
f_z = l - (1 - y);
F = Function('f_x',{x, z},{f_x, f_q, f_z});

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
z0 = [0; 1; 1];

% "Lift" initial conditions
Xk = MX.sym('X0', nx);
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

% Total number of optimization variables and complementarity pairs
NX = nx + N*(nx + nz);
NCOMP = N*2;

% LCQP requires complementarity matrices
S1 = zeros(NCOMP, NX);
S2 = zeros(NCOMP, NX);
compCounter = 1;

%% Formulate the NLP
for k=0:N-1
    % New node
    Xkj = MX.sym(['X_' num2str(k)], nx);
    Zkj = MX.sym(['Z_' num2str(k)], nz);
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

    % Update (algebraic state) indices
    newComplementarities = ind_total(end)+1:ind_total(end)+nz;        
    ind_z = [ind_z, newComplementarities];
    ind_total  = [ind_total,newComplementarities];
    
    % Build complementarity matrices (required for easy compl. evaluation)
    % Get new indices
    yInd = newComplementarities(1);
    lam0Ind = newComplementarities(2);
    lInd = newComplementarities(3);
    xInd = newStates(1);

    % y*lambda0
    S1(compCounter, yInd) = 1;
    S2(compCounter, lam0Ind) = 1;
    compCounter = compCounter + 1;

    % (1-y)*lambda1
    S1(compCounter, lInd) = 1;
    S2(compCounter, [xInd, lam0Ind]) = [1, 1];
    compCounter = compCounter + 1;
    
    % Collocation equation
    Xk_end = D(1)*Xk;
    xp = C(1,2)*Xk + C(2,2)*Xkj;
    
    % Obtain algebraic variables
    y = Zkj(1);
    lam0 = Zkj(2);
    l = Zkj(3);
            
    lam1 = Xkj + lam0;
    
    % Linear constraints on algbraic vars
    % 1) Positivity of lambda1:
    g = {g{:}, lam1};
    lbg = [lbg; 0];
    ubg = [ubg; inf];
    
    g = {g{:}, l - (1 - y)};
    lbg = [lbg; 0];
    ubg = [ubg; 0];

    % ODE and objective
    [fx, fq, fz] = F(Xkj, Zkj);

    % collect discretized DAE equations
    g = {g{:}, h*fx - xp, fz};
    lbg = [lbg; 0; 0];
    ubg = [ubg; 0; 0];

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

% Create array containing all optimization variables
x = vertcat(w{:});

%% Get matrices
% Constraint matrix
constr = vertcat(g{:});

% Create QP from NLP
Constr = Function('Constr', {x}, {constr});
A_Fun = Function('A_Fun', {x}, {jacobian(constr, x)});
A = full(A_Fun(zeros(size(x))));

% Linearization correction term
constr_constant = Constr(zeros(size(x)));
lbA = lbg - full(constr_constant);
ubA = ubg - full(constr_constant);

% Box constraints (rename)
lb = lbw;
ub = ubw;

% Complementarity matrices (rename)
L = S1;
R = S2;

% Linear objective term
J_Jac_Fun = Function('J_Jac_fun', {x}, {jacobian(J, x)});
g = full(J_Jac_Fun(zeros(size(x))))';

% Quadratic objective term
Q_Fun = Function('Q_fun', {x}, {hessian(J, x)});
Q = full(Q_Fun(zeros(size(x))));

% Build initial guess
initGuess = BuildInitialGuessEuler(@(x) 2 - sign(x), -1.8, h, N+1);    
w0(ind_x) = initGuess;

% LCQP parameters
params.x0 = w0;
params.initialPenaltyParameter = 0.01;
params.solveZeroPenaltyFirst = true;
params.penaltyUpdateFactor = 10;
params.maxIterations = 1000;
params.printLevel = 0;

