function [params] = GetLCQPowSettings(name, casadi_formulation)

% Penalty settings
complementaritySettings = GetComplementaritySettings();

% Solver Settings
params.printLevel = 0;
params.initialPenaltyParameter = complementaritySettings.rho0;
params.penaltyUpdateFactor = complementaritySettings.beta;
params.maxPenaltyParameter = complementaritySettings.rhoMax;
params.complementarityTolerance = complementaritySettings.complementarityTolerance;
params.stationarityTolerance = 1e-7;

% Initial guess
if isfield(casadi_formulation, "x0")
    params.x0 = casadi_formulation.x0;
end

if (nargin == 0 || name == "default")
    return
elseif (name == "NoLeyffer")
    params.nDynamicPenalty = 0;
elseif (name == "LargeRho0")
    params.initialPenaltyParameter = 100;
elseif (name == "SmallRho0")
    params.initialPenaltyParameter = 10e-10;
elseif (name == "SmallFast")
    params.initialPenaltyParameter = 10e-10;
    params.penaltyUpdateFactor = 10;
elseif (name == "SmallSlow")
    params.initialPenaltyParameter = 10e-10;
    params.penaltyUpdateFactor = 1.1;
elseif (name == "NoPerturbation")
    params.perturbStep = false;
elseif (name == "NoZeroPen")
    params.solveZeroPenaltyFirst = false;
elseif (name == "LowStationarity")
    params.stationarityTolerance = 10e-6;
elseif (name == "LowComplementarity")
    params.complementarityTolerance = 10e-6;
elseif (name == "LowPrecision")
    params.stationarityTolerance = 10e-5;
    params.complementarityTolerance = 10e-5;
else
    error("Option " + name +" not yet setupt!\n");
end

end

