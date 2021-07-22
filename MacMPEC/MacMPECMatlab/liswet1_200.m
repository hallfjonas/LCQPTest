%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Build and solve
problem = BuildAndSolveLiswet('liswet1-200.dat');
