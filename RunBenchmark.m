close all; clear all; clc;

%% Add required paths
% Adjust CasADi and qpOASES path to your local settings:
% LCQPanther (LCQP C++ solver)
addpath("~/lcqpOASES/interfaces/matlab");

% LCQP MATLAB solver (and dependencies)
addpath("~/LCQP");
addpath("~/qpOASES/interfaces/matlab"); % qpOASES

%% Perapre list of problems
files = dir('Problems');

for i = 1:length(files)
    
    clearvars -except files i;
    
    file = files(i);    
    if (~file.isdir || file.name == "." || file.name == "..")
        continue;
    end
    
    problem_dir = [file.folder, '/', file.name];
    problem_name = file.name;
    
    problem_files = dir(problem_dir);
    main_file = [];
    for j = 1:length(problem_files)
        problem_file = problem_files(j);
        if (problem_file.name == "main.m")
            main_file = [problem_dir, '/main.m'];
            break;
        end 
    end
            
    if (isempty(main_file))
        fprintf("Skipping %s since no main.m found.\n", problem_dir);
        continue;
    end
    
    fprintf("Sourcing file %s.\n", main_file);
    run(main_file);
    
    RunSolvers(problem_name, Q, g, L, R, A, lbA, ubA, lb, ub, params);
end