clc; clear all; close all;

qpecgen;
load("qpecgen_data.mat")

% Extract variable dimensions
nx = length(c);
ny = length(d);
nlam = size(E,1);

% Generate objective
Q = blkdiag(P, 1000*eps*eye(nlam,nlam));
g = [c; d; zeros(nlam,1)];

% Linear inequality constraints
% (notation clash: A on rhs is from qpecgen to describe 
% Z = {(x,y): A[x,y] <= -a}
A = [A, zeros(size(A,1),nlam)];
lbA = -inf*a;
ubA = -a;

% Generate linear constraints
A = [A; N, M, E'];
lbA = [lbA; -q];
ubA = [ubA; -q];

% Complementarity constraints
L = -[D, E, zeros(nlam,nlam)];
R = [zeros(nlam,nx), zeros(nlam,ny), eye(nlam,nlam)];
lbL = b;
ubL = inf(size(L,1),1);
lbR = zeros(size(L,1),1);
ubR = inf(size(L,1),1);

addpath("~/LCQPow/build/lib/");

param.printLevel = 2;
param.initialPenaltyParameter = 10e-10;
param.stationarityTolerance = 10e-7;
[x,y,stats] = LCQPow(Q,g,L,R,lbL,ubL,lbR,ubR,param);
