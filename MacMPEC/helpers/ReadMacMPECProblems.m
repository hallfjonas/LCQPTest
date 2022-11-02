
function [problems] = ReadMacMPECProblems(problems_dir)

problems = {};

% Loop over all dat files
files = dir([problems_dir, '/*.m']);
k = 1;
for i = 1:length(files)
    
    % Generate the casadi problem formulation
    run(fullfile(files(i).folder, files(i).name));

    % Append to the problem set
    problems{k}.file = files(i);
    problems{k}.name = files(i).name(1:end-2);
    problems{k}.casadi_formulation = problem;
    
    k = k+1;
end

end

