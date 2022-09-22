function [opts_ipopt] = GetIPOPTOptions()

opts_ipopt = struct;
opts_ipopt.ipopt.nlp_scaling_method = 'none';

% Print level = 1 is required in order to obtain the t_proc_total timings
opts_ipopt.ipopt.print_level = 1;

opts_ipopt.ipopt.bound_relax_factor = 1e-10;
opts_ipopt.print_time = 0;
opts_ipopt.print_out = 0;
opts_ipopt.ipopt.mu_strategy = 'adaptive';
opts_ipopt.ipopt.mu_oracle = 'quality-function';
opts_ipopt.ipopt.tol = 1e-10;

end