function [problem] = BuildAndSolvePortfl(dataFile)

% Load CasADi
import casadi.*;

% Load AMPL
ampl = AMPL;

%% Load Data
ampl.read("data/portfl-i.mod");
ampl.readData(['data/', dataFile]);
LoadAMPLParams(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
% Dimension
nv = NS + NS + 1 + NR;
w = SX.sym('w', nv, 1);
s = w(1:NS);
m = w(NS+1:2*NS);
l = w(2*NS+1);
r = w(2*NS+2:2*NS+1+NR);
lb = zeros(nv,1);
ub = inf(nv,1);
lb(2*NS+1) = -inf;

% Objective
obj = (s - sol)'*(s - sol) + r'*r;

% Constraints
constr = {};
for k = 1:NS    
    % KKT
    sumTerm = 0;
    for i = 1:NR
        sumTerm = sumTerm + s'*F(:,i) - (R(i)+r(i))*F(k,i);
    end
    
    sumTerm = 2*sumTerm  - l - m(k);
    
    constr = {...
        constr{:}, ...
        sumTerm ...
    };
end

% controls
constr = {constr{:}, sum(s)};

% Constraint bounds
lbA = [zeros(NS,1); 1];
ubA = lbA;

% Complementarities
compl_L = s;
compl_R = m;

% Initial guess
x0 = zeros(nv,1);
x0(1:NS) = 1/NS*ones(NS,1);

problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA, ...
    lb, ...
    ub, ...
    x0 ...
);

end