function [ obj_ast ] = GetMacMPECOptimalObjective( name )
    
% Get Modpath
[modpath, datpath] = GetPaths(name);
[~, modfile] = fileparts(modpath);

% Read MacMPEC solutions
addpath('problem_table');
sols = readtable('MacMPECSolutions.csv');

[val, ind] = find(sols.modFile == modfile);

obj_ast = sols.solution(ind);

end