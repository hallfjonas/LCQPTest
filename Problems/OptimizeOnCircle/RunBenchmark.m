close all; clear all; clc;

%% Modify which solvers you want to use
solvers.LCQP_matlab.use = true;
solvers.LCQPanther_qpOSAES_dense.use = true;
solvers.LCQPanther_qpOSAES.use = true;
solvers.LCQPanther_qpOSAES_Schur.use = false;
solvers.LCQPanther_OSQP.use = false;
solvers.IPOPT_smooth.use = false;
solvers.IPOPT_relaxed.use = false;
solvers.IPOPT_penalty.use = true;

%% Add required paths
% Adjust CasADi and qpOASES path to your local settings:
% LCQPanther (LCQP C++ solver)
addpath("~/LCQPanther/interfaces/matlab");

% LCQP MATLAB solver (and dependencies)
addpath("~/LCQP");
addpath("~/qpOASES/interfaces/matlab");

% Load CasADi
addpath("~/casadi-matlab2014b-v3.5.5/");

%% Perapre list of problems
files = dir('Problems');
NVals = 20:5:220;

solvers = InitializeSolvers(length(NVals), solvers);

for i = 1:length(NVals)
        
    problem.IPOPTForm = IPOPTFormulation(NVals(i));
    problem.LCQP_std_form = GetLCQPFromIPOPTForm(problem.IPOPTForm);    
    
    solvers = RunSolvers(problem, solvers, i);
end

% Save stats
if ~exist('saved_variables', 'dir')
   mkdir('saved_variables')
end

outfile = ['saved_variables/', 'OOUC', '.mat'];

fprintf("Saving to file %s\n", outfile);
save(outfile, 'solvers');

%% Create Performance Plots
run('CreatePerformancePlot.m');