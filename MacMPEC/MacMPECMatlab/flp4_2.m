%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Build and solve
problem = BuildAndSolveFLP4('flp4-2.dat');