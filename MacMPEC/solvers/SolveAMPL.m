function [solution] = SolveMPCC(name, solver)

import casadi.*;

currdir = pwd;
cd MacMPECMatlab/;
run([name, '.m']);
cd(currdir);

addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab");
setUp;
ampl = AMPL;

% Extract dimension
nV = size(problem.Q,1);
nC = 0; 
if (isfield(problem,'A'))
    nC = size(problem.A,1);
    A = full(problem.A);
end
nComp = size(problem.L,1);

% Assign index sets
ampl.eval(sprintf("set N = 1..%d;", nV));
ampl.eval(sprintf("set M = 1..%d;", nC));
ampl.eval(sprintf("set L = 1..%d;", nComp));

% Optimization variable
ampl.eval('var x{N};');

% Build objective function
Q = full(problem.Q);
obj_str = "";
for i = 1:nV
    % Generate xi
    xi = "x[" + num2str(i) + "]";
    
    % Quadratic terms
    for j = 1:nV
        if abs(Q(i,j)) > eps
            if (~strcmp(obj_str, ""))
                obj_str = obj_str + " + ";
            end

            % Generate xj
            xj = "x[" + num2str(j) + "]";

            % generate quadratic contribution including xi and xj
            obj_str = obj_str + "0.5*" + xi + "*" + num2str(Q(i,j)) + "*" + xj;
        end
    end

    % Linear Terms
    if (abs(problem.g(i)) > eps)
        if (~strcmp(obj_str, ""))
            obj_str = obj_str + " + ";
        end
        obj_str = obj_str + num2str(problem.g(i)) + "*" + xi;
    end
end
ampl.eval(sprintf("%s: %s;", "minimize J", obj_str));

% Box constraints
for i = 1:nV
    if (problem.lb(i) > -inf)
        ampl.eval(sprintf("lb_%d: x[%d] >= %f;", i, i, problem.lb(i)));
    end
    if (problem.ub(i) < inf)
        ampl.eval(sprintf("ub_%d: x[%d] <= %f;", i, i, problem.ub(i)));
    end
end

% Linear constraints
for i = 1:nC 
    constr_str = "";
    
    for j = 1:nV
        if abs(A(i,j)) > eps
            if (~strcmp(constr_str, ""))
                constr_str = constr_str + " + ";
            end
            xj = "x[" + num2str(j) + "]";
            constr_str = constr_str + num2str(A(i,j)) + "*" + xj;
        end
    end

    if (problem.lbA(i) > -inf)
        ampl.eval(sprintf("lbA_%d: %s >= %f;", i, constr_str, problem.lbA(i)));
    end

    if (problem.ubA(i) < inf)
        ampl.eval(sprintf("ubA_%d: %s <= %f;", i, constr_str, problem.ubA(i)));
    end
end

% Complementarity constraints
L = full(problem.L);
R = full(problem.R);
for i = 1:nComp 
    comp_l_str = "";
    comp_r_str = "";
    
    % build left complementarity
    for j = 1:nV
        if abs(L(i,j)) > eps

            if (~strcmp(comp_l_str, ""))
                comp_l_str = comp_l_str + " + ";
            end

            xj = "x[" + num2str(j) + "]";
            comp_l_str = comp_l_str + num2str(L(i,j)) + "*" + xj;
        end
    end

    % build right complementarity
    for j = 1:nV
        if abs(R(i,j)) > eps

            if (~strcmp(comp_r_str, ""))
                comp_r_str = comp_r_str + " + ";
            end

            xj = "x[" + num2str(j) + "]";
            comp_r_str = comp_r_str + num2str(R(i,j)) + "*" + xj;
        end
    end

    % Impose constraints
    ampl.eval(sprintf("comp_%d: 0 <= %s complements %s >= 0;", i, comp_l_str, comp_r_str));
end

% Set solver
ampl.setOption('solver', solver);

% Solve
ampl.solve

% Output stats
solution = {};
solution.x = zeros(nV,1);
for i = 1:nV
    solution.x(i) = ampl.getValue(sprintf('x[%d]', i));
end
solution.stats.obj = full(problem.Obj(solution.x));

% TODO: Why is the complementarity satisfied????
solution.stats.compl = full(problem.Phi(solution.x));

solution.stats.n_x = nV;
solution.stats.n_c = nC;
solution.stats.n_comp = nComp;
solution.stats.elapsed_time = ampl.getValue('_total_solve_time');
solution.stats.exit_flag = ampl.getValue('solve_result_num');

end
