function [problem] = BuildAndSolveQpec(modFile)

% Load CasADi
import casadi.*;

% Load AMPL
ampl = AMPL;

%% Load Data
ampl.read(['data/', modFile]);
LoadAMPLParams(ampl);
LoadAMPLSets(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
nv = n+m;
w = SX.sym('w', nv, 1);
x = w(1:n);
y = w(n+1:n+m);
lb = -inf(nv,1);
ub = inf(nv,1);
lb(n+1:n+m) = 0;

obj = 0;
% Objective
for j=1:length(N)
    i = N(j);
    obj = obj + (x(i) + rr(i))^2;
end
for i=1:length(M)
    j = M(i);
    obj = obj + (y(j) + ssvec(j))^2;
end

% Complementarities
compl_L = {};
compl_R = {};
for j = 1:length(N)
    i = N(j);
    compl_L = {compl_L{:}, y(i) - x(i)};
    compl_R = {compl_R{:}, y(i)};
end

% Why not just eliminate y(i) = 0 for i > n?
for j = 1:length(NM)
    i = NM(j);
    compl_L = {compl_L{:}, y(i)};
    compl_R = {compl_R{:}, y(i)};
end

% Initial guess
x0 = ones(nv,1);

problem = ObtainLCQP(...
    w, ...
    obj, ...
    [], ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    [], ...
    [], ...
    lb, ...
    ub, ...
    x0 ...
);

end