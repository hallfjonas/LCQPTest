%% Clean and Load
close all; 

% Load CasADi
import casadi.*;

ampl = AMPL;

%% Load Data
ampl.read("data/sl1.mod");
LoadAMPLParams(ampl);

% Close the AMPL object
ampl.close();

%% Build Problem
% Dimension
nv = 2 + 3 + 3 + 1;
nc = 2;

% Variables and box constraints
w = SX.sym('w', nv, 1);
x = w(1:2);
z = w(3:5);
l = w(6:8);
one = w(nv);

% Box Constraints
lb = -inf(nv,1);
ub = inf(nv,1);
lb(3:5) = zl;
ub(3:5) = zu;
lb(6:8) = zeros(3,1);
lb(nv) = 1;
ub(nv) = 1;

% Objective
obj = (x(1) - 2)^2 + x(2)^2;

% Constraints
constr = {...
    0.02*x(1) - 10*l(1) - l(2), ...
    2*x(2) - l(1) - l(3) ...
};
    
lbA = [0; 0]; 
ubA = lbA; 

% Complementarities
compl_L = {
    10*x(1) + x(2) - (10*one + z(1)), ...
    x(1) - (2*one + z(2)), ...
    x(2) - 50*z(3), ...    
};
compl_R = l;
    
% Get LCQP
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
