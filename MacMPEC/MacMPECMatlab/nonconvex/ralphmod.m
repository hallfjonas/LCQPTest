%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Build and solve
[x, problem] = BuildAndSolveRalphmod('ralphmod.dat');
