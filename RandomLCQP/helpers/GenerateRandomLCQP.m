
function [problem] = GenerateRandomLCQP(n, m, n_cc)

% Random LCQP
% Generate selection matrices
S1 = diag([zeros(1,n-2*n_cc) ones(1,n_cc) zeros(1,n_cc)]);
ind1 = find(diag(S1));
S2 = diag([zeros(1,n-2*n_cc) zeros(1,n_cc) ones(1,n_cc) ]);
ind2 = find(diag(S2));
problem.L = S1(ind1, :);
problem.R = S2(ind2, :);
problem.lbL = rand(n_cc,1);
problem.lbR = rand(n_cc,1);

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
problem.Q = V*lambda*V';

% 2) Linear objective term
problem.g = rand(n,1);

% linear (in)equality constraints
problem.A = rand(m,n);
problem.lbA = rand(m,1);
problem.ubA = problem.lbA + round(rand(m,1)).*rand(m,1);

problem.rho0 = 0.01;
problem.beta = 2;
problem.rhoMax = 1000000;
end