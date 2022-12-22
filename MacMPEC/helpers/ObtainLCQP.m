
function [casadi_formulation] = ObtainLCQP(x, J, constr, compl_L, compl_R, lbA, ubA, lb, ub, x0)

import casadi.*

% Regularization
Q_Fun = Function('Q_fun', {x}, {hessian(J, x)});
Q = full(Q_Fun(zeros(size(x))));
ev = eig(Q);
for i=1:length(ev)
    if (ev(i) < eps)
        J = J + 100*eps*x(i)*x(i);
    end
end

casadi_formulation.x = x;
casadi_formulation.J = J;
casadi_formulation.constr = constr;
casadi_formulation.compl_L = compl_L;
casadi_formulation.compl_R = compl_R;
casadi_formulation.lbA = lbA;
casadi_formulation.ubA = ubA;
casadi_formulation.lb = lb;
casadi_formulation.ub = ub;
casadi_formulation.Obj = Function('Obj', {x}, {J});
casadi_formulation.Phi = Function('Phi', {x}, {max(compl_L.*compl_R)});

% Only assign initial guess if it was passed
if nargin > 9
    casadi_formulation.x0 = x0;
end

end
