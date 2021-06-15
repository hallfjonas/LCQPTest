function [ problems ] = ReadMacMPECProblems()

problems = containers.Map;

% Loop over all dat files
files = dir('Problems/*.nl');
for i = 1:length(files)
    
    problem = {};
    problem.file = files(i);
    problem.name = problem.file.name;
    problem.path = [problem.file.folder, '/', problem.name];
    
    problem.AMPLProblem = amplread(problem.path);
    
    problems(problem.name) = problem;
end

end