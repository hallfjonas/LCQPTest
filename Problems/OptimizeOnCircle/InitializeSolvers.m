function[solvers] = InitializeSolvers(nexp, solvers)

fn = fieldnames(solvers);
for k=1:numel(fn)
    if( solvers.(fn{k}).use )
        solvers.(fn{k}).time_vals = zeros(nexp,1);
        solvers.(fn{k}).obj_vals = zeros(nexp,1);
        solvers.(fn{k}).compl_vals = zeros(nexp,1);
        solvers.(fn{k}).penalty_updates = zeros(nexp,1);
        solvers.(fn{k}).iter_total = zeros(nexp,1);
        solvers.(fn{k}).exit_flag = zeros(nexp,1);
    end
end
end