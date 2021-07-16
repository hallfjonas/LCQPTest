function [ param ] = GetLCQPParameters( )

param.initialPenaltyParameter = 1e-0;
param.stationarityTolerance = 1e-6;
param.printLevel = 2;
param.storeSteps = false;
param.maxIterations = 10000;
param.qpSolver = 1;

end