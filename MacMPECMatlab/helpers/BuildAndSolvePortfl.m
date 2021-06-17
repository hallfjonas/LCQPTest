function [x, problem] = BuildAndSolvePortfl(dataFile)

% Load LCQPanther interface
addpath('~/LCQPanther/interfaces/matlab')

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");
import casadi.*;

% Load AMPL
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab/");
setUp;
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
        innerSum = 0;
        for j = 1:NS
            innerSum = s(j)*F(j,i);
        end
        sumTerm = sumTerm + 2*(innerSum - (R(i)+r(i)))*F(k,i);
    end
    
    sumTerm = sumTerm  - l - m(k);
    
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
    
problem = ObtainLCQP(...
    w, ...
    obj, ...
    vertcat(constr{:}), ...
    vertcat(compl_L{:}), ...
    vertcat(compl_R{:}), ...
    lbA, ...
    ubA ...
);

% Solve
params.printLevel = 2;
params.initialPenaltyParameter = 1e-5;
params.x0 = zeros(nv,1);
params.x0(1:NS) = 1/NS*ones(NS,1);
x = LCQPanther(...
    problem.Q, ...
    problem.g, ...
    problem.L, ...
    problem.R, ...
    problem.A, ...
    problem.lbA, ...
    problem.ubA, ...
    lb, ...
    ub, ...
    params ...
);
problem.obj(x)

end