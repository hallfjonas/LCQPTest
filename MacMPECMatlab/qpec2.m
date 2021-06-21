%% Clean and Load
close all; clear all; clc;

% Load Helpers
addpath("helpers");

% Build and solve
[x, problem] = BuildAndSolveQpec('qpec2.mod');
