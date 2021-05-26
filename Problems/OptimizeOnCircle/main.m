%% Build optim on unit circle
%
%   min   (x-xk)'*Q*(x-xk)
%   s.t.   ||x||^2 = 1
%

% Circle discretization
N = 100;
nz = 2 + 2*N;

% Reference point
xk = [0.5; -0.6];

% Objective
Qx = [17 -15; -15 17];
Q = eps*eye(nz);
Q(1:2,1:2) = Qx;
g = zeros(nz,1);
g(1:2) = -xk'*Qx;

% Allocate Constraints
A = zeros(N+1, nz);
lbA = ones(N+1, 1);
ubA = lbA;

% Allocate Complementarity pairs
L = zeros(N, nz);
R = zeros(N, nz);

% Fill constraints
for i = 1:N
    % Equality constraint ([cos sin]'*x + lambda = 1)
    A(i, 1:2) = [cos(2*pi*i/N) sin(2*pi*i/N)];
    A(i, 2 + 2*i - 1) = 1;

    % Convex combination constraint (sum theta = 1)
    A(N+1, 2+2*i) = 1;

    % Complementarity constraint
    L(i, 2 + 2*i - 1) = 1;
    R(i, 2 + 2*i) = 1;
end

% Box constraints (non-negativity on compl. var. and unbounded state var)
lb = zeros(nz,1);
ub = inf(nz,1);
lb(1:2) = -inf(2,1);

% Algorithm parameters
params.x0 = ones(nz,1); params.x0(1:2) = xk;
params.initialPenaltyParameter = 0.001;
params.penaltyUpdateFactor = 2;
params.solveZeroPenaltyFirst = true;
params.printLevel = 0;
