function [problem] = BuildAndSolveLiswet(dataFile)

% Load LCQPow interface
addpath('~/LCQPow/build/lib')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

% Load AMPL
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab/");
setUp;
ampl = AMPL;

%% Load Data
ampl.read("data/liswet1-inv.mod");
ampl.readData(['data/', dataFile]);
LoadAMPLParams(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
% Dimension
nv = 3*N+K;
nc = N+K+1;

% Variables and box constraints
w = SX.sym('w', nv, 1);
z = w(1:N);
x = w(N+1:2*N+K);
l = w(2*N+K+1:3*N+K);

% Box Constraints 
lb = zeros(nv,1);
ub = inf(nv,1);
lb(N+1:2*N+K) = -inf(N+K,1);

% Objective
obj = (x-x_star)'*(x - x_star);

% Constraints
constr = {};
for i = 1:N+K
    
    % KKT
    sumTerm = 0;
    for j = max(i-K, 1):min(i,N)
        sumTerm = sumTerm + C(j+K-i+1)*l(j);
    end
    
    constr = {...
        constr{:}, ...
        x(i) - sumTerm ...
    };
end

% controls
constr = {constr{:}, sum(z)};

% Constraint bounds
lbA = [sqrt(T) + 0.1*sin(1:N+K)'; 0.2];
ubA = [sqrt(T) + 0.1*sin(1:N+K)'; inf];

% Complementarities
compl_L = l;
compl_R = {};
for j = 1:N
    complTerm = -z(j);
    for i = 1:K+1
        complTerm = complTerm + C(i)*x(j+K-i+1);
    end
    compl_R = {...
        compl_R{:}, ...
        complTerm ...
    };
end
    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA, ...
    lb, ...
    ub ...
);

% Regularization
problem.Q(1:N, 1:N) = 10*eps*eye(N);
problem.Q((2*N+K+1):(3*N+K), (2*N+K+1):(3*N+K)) = 10*eps*eye(N);
end