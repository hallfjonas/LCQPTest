function [problem] = BuildAndSolveMonteiro(modFile)

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi/");
import casadi.*;

% Load AMPL
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab/");
setUp;
ampl = AMPL;

%% Load Data
ampl.read(['data/', modFile]);
LoadAMPLParams(ampl);
LoadAMPLSets(ampl);
vars = LoadAMPLVariables(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem

w = {};
varkeys = vars.keys;
for i=1:length(varkeys)
    varstruct = vars(varkeys{i});
    w = {w{:}, varstruct.var};
end

one = SX.sym('one', 1);
w = vertcat(w{:}, one);
nv = length(w);
lb = -inf(nv,1);
ub = inf(nv,1);
lb(nv) = 1;
ub(nv) = 1;

obj = 0;
% Objective
for i=1:length(D)
    n = D(i);
    obj = obj + c(n)*QD(n)-d(n)*QD(n)^2;
end
for i=1:length(Sf)
    k = Sf(i);
    obj = obj + a(k)*QS(k)+(b(k)/2)*(QS(k)^2);
end
for k=1:size(A, 1)
    i = A(k,1);
    j = A(k,2);
    obj = obj + teta(i,j)*Ts(i,j);
end
for k = 1:length(P)
    l = P(k);
    
    if (~contains(Sf, l))
        obj = obj + miu(l)*QS_s(l)+a(l)*QS(l)+b(l)*QS(l)^2;
    end
end
    
    
obj = 0.5*(x'*x) + sum(y);

% Build LCQP
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(), ...
    vertcat(), ...
    vertcat(), ...
    [], ...
    [] ...
);

% Regularization
problem.Q(n+1:nv, n+1:nv) = 10*eps*eye(nv-n,nv-n);

% Complementarity matrices
problem.L = [zeros(size(N)), eye(size(M)), zeros(size(q))];
problem.R = [N, M, q];

% Linear constraints
problem.A = [A, zeros(p, m+1)];
problem.lbA = -inf(nc, 1);
problem.ubA = b;

end