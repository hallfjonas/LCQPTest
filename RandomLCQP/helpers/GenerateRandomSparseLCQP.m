
function [problem] = GenerateRandomSparseLCQP(nx, m, n_cc, N)

% Random LCQP

% Generate random objective function
Q = [];
Q_min = 0;
Q_max = 1e2;

A = [];
L = [];
R = [];

for i=1:N
    % objective blocks: Symmetrize and mirror 
    Qk =  Q_min + (Q_max-Q_min).*rand(nx);
    Qk = 0.5*(Qk+Qk');
    [V,lambda] = eig(Qk);
    lambda = abs(lambda);
    Qk = V*lambda*V';
    Q = blkdiag(Q, Qk);
    
    % Linear Constraints
    Ak = rand(m,nx);
    A = blkdiag(A, Ak);
    
    % Complementarity Blocks
    Lk = rand(n_cc, nx);
    Rk = rand(n_cc, nx);
    L = blkdiag(L, Lk);
    R = blkdiag(R, Rk);
end

problem.Q = Q;
problem.g = rand(N*nx,1);
problem.L = L;
problem.R = R;
problem.lbL = rand(N*n_cc, 1);
problem.lbR = rand(N*n_cc, 1);
problem.A = A;
problem.lbA = rand(N*m, 1);
problem.ubA = problem.lbA + rand(N*m, 1);

problem.rho0 = 0.01;
problem.beta = 2;
problem.rhoMax = 1000000;

end