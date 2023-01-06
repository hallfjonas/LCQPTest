close all; clear all; clc;

if ~endsWith(pwd,'LCQPTest')
    error("Please navigate to the base directory of the 'LCQPTest' benchmark.");
end

% Provide a test name. The solutions will be stored to the directories
%     1) MacMPEC/solutions/test_name/...     
%     2) IVOCP/solutions/test_name/...     
%     3) MovingMasses/solutions/test_name/...     
test_name = "mpc_review";

% Adjust the paths in this file
addpaths;

%% 1) MacMPEC Benchmark
clearvars -except test_name;
outdir = fullfile("MacMPEC/solutions", test_name);
if ~isfile(fullfile(outdir, 'sol.mat'))
   error("Solution file " + fullfile(outdir, "sol.mat") + " not found (please run benchmark first).");
end

% Create the performance plots (this will take a few seconds)
CreateMacMPECPlots(outdir);

%% 2) Initial Value Optimal Control Problem Benchmark
clearvars -except test_name;
outdir = fullfile("IVOCP/solutions", test_name);
if ~isfile(fullfile(outdir, 'sol.mat'))
   error("Solution file " + fullfile(outdir, "sol.mat") + " not found (please run benchmark first).");
end

% Create the performance plots (this will take a few seconds)
CreateIVOCPPlots(outdir);

%% 3) Moving Masses Benchmark
clearvars -except test_name;
outdir = fullfile("MovingMasses/solutions", test_name);
if ~isfile(fullfile(outdir, 'sol.mat'))
   error("Solution file " + fullfile(outdir, "sol.mat") + " not found (please run benchmark first).");
end

% Create the performance plots (this will take a few seconds)
CreateMovingMassesPlots(outdir);
