function [LCQPForm] = GetLCQPFromIPOPTForm(IPOPTForm)

% Requires the following struct fields in IPOPTForm
% 1) x: The optimization variables
% 2) obj: The objective function 
% 3) compl_L: The lhs selector function
% 4) compl_R: The rhs selector function
% 5) constr: the constraint function*
% 6) lbg, ubg: The constraint bounds*
% 7) lb, ub: The box constraints*

import casadi.*;

% Create QP from NLP
% Variables
x = IPOPTForm.x;
nul = zeros(size(x));

% Objective
% Linear objective term
J_Jac_Fun = Function('J_Jac_fun', {x}, {jacobian(IPOPTForm.obj, x)});
LCQPForm.g = full(J_Jac_Fun(nul))';

% Quadratic objective term
Q_Fun = Function('Q_fun', {x}, {hessian(IPOPTForm.obj, x)});
LCQPForm.Q = full(Q_Fun(nul));

% Complementarities
L_Jac_Fun = Function('L_Jac_fun', {x}, {jacobian(IPOPTForm.compl_L, x)});
LCQPForm.L = full(L_Jac_Fun(nul));
R_Jac_Fun = Function('R_Jac_fun', {x}, {jacobian(IPOPTForm.compl_R, x)});
LCQPForm.R = full(R_Jac_Fun(nul));

% Make sure complementarity type is supported
L_fun = Function('L_fun', {x}, {IPOPTForm.compl_L});
R_fun = Function('R_fun', {x}, {IPOPTForm.compl_R});
if (max(abs(full(L_fun(nul)))) > eps || max(abs(full(R_fun(nul)))) > eps)
    error("Complementarity functions with constant term are not supported.");
end

% Constraints
if (isfield(IPOPTForm, 'constr'))
    Constr = Function('Constr', {x}, {IPOPTForm.constr});
    A_Fun = Function('A_Fun', {x}, {jacobian(IPOPTForm.constr, x)});
    LCQPForm.A = full(A_Fun(nul));
    
    if (~isfield(IPOPTForm, 'lbA') || ~isfield(IPOPTForm, 'ubA'))
        error("Require lbg, ubg if passing constraints.");
    end
    
    % Linearization correction term
    constr_constant = Constr(zeros(size(x)));
    LCQPForm.lbA = IPOPTForm.lbA - full(constr_constant);
    LCQPForm.ubA = IPOPTForm.ubA - full(constr_constant);
else
    LCQPForm.A = [];
    LCQPForm.lbA = [];
    LCQPForm.ubA = [];
end

% Box constraints
if (isfield(IPOPTForm, 'lb'))
    LCQPForm.lb = IPOPTForm.lb;
else
    LCQPForm.lb = [];
end

if (isfield(IPOPTForm, 'ub'))
    LCQPForm.ub = IPOPTForm.ub;
else
    LCQPForm.ub = [];
end

end