%% Random QP MPCC
n = 300;
m = 100;
n_cc = 100;

% Generate selection matrices
S1 = diag([zeros(1,n-2*n_cc) ones(1,n_cc) zeros(1,n_cc)]);
ind1 = find(diag(S1));
S2 = diag([zeros(1,n-2*n_cc) zeros(1,n_cc) ones(1,n_cc) ]);
ind2 = find(diag(S2));
L = S1(ind1, :);
R = S2(ind2, :);

% Generate random objective function
% Rescale
Q_min = 0;
Q_max = 1e2;

% 1) Hessian
Q = Q_min + (Q_max-Q_min).*rand(n);
Q = 0.5*(Q+Q');
[V,lambda] = eig(Q);

% mirror (for strict convexity)
lambda = abs(lambda);
Q = V*lambda*V';

% 2) Linear objective term
g = rand(n,1);

% linear (in)equality constraints
A = rand(m,n);
lbA = rand(m,1);
ubA = lbA + round(rand(m,1)).*rand(m,1);

% Box constraints (only on complementarities)
lb = -inf*ones(n,1);
ub = inf*ones(n,1);
lb(ind1) = 0;
lb(ind2) = 0;

% Solution parameters
params.x0 = 0.01*ones(n,1);
params.initialPenaltyParameter = 1;
params.penaltyUpdateFactor = 10;
params.solveZeroPenaltyFirst = true;
params.printLevel = 0;