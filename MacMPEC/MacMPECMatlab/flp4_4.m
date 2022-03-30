%% Clean and Load
close all; 

% Load Helpers
addpath("helpers");

% Build and solve
problem = BuildAndSolveFLP4('flp4-4.dat');
