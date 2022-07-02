%% Clean and Load
close all; 

% Load Helpers
addpath("helpers");

% Build and solve
problem = BuildAndSolvePortfl('portfl3.dat');
