
function [ sol ] = CallIPOPTSolver( solver, IPOPT_formulation, rho )

    if (isfield(IPOPT_formulation, 'x0') && isfield(IPOPT_formulation, 'lb'))
        sol = solver( ...
            'x0', IPOPT_formulation.x0, ...
            'lbg', IPOPT_formulation.lb_constr, ...
            'ubg', IPOPT_formulation.ub_constr, ...
            'lbx', IPOPT_formulation.lb, ...
            'ubx', IPOPT_formulation.ub, ...
            'p', rho ...
        );
        return;
    end

    if (~isfield(IPOPT_formulation, 'x0') && isfield(IPOPT_formulation, 'lb'))
        sol = solver( ...
            'lbg', IPOPT_formulation.lb_constr, ...
            'ubg', IPOPT_formulation.ub_constr, ...
            'lbx', IPOPT_formulation.lb, ...
            'ubx', IPOPT_formulation.ub, ...
            'p', rho ...
        );
        return;
    end
    
    
    if (isfield(IPOPT_formulation, 'x0') && ~isfield(IPOPT_formulation, 'lb'))
        sol = solver( ...
            'x0', IPOPT_formulation.x0, ...
            'lbg', IPOPT_formulation.lb_constr, ...
            'ubg', IPOPT_formulation.ub_constr, ...
            'p', rho ...
        );
        return;
    end
    
    sol = solver( ...
        'lbg', IPOPT_formulation.lb_constr, ...
        'ubg', IPOPT_formulation.ub_constr, ...
        'p', rho ...
    );
    return;    
end
