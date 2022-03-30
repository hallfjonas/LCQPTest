
function [problems] = ReadMacMPECProblems(problems_dir)

problems = {};

% Loop over all dat files
files = dir([problems_dir, '/*.m']);
k = 1;
for i = 1:length(files)
    
    problems{k}.file = files(i);
    problems{k}.name = files(i).name(1:end-2);   
    
    k = k+1;
end

end

