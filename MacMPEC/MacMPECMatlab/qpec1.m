%% Clean and Load
close all; clear all;

% Load Helpers
addpath("helpers");

% Build and solve
problem = BuildAndSolveQpec('qpec1.mod');