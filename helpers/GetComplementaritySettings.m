function [settings] = GetComplementaritySettings()

% Penalty homotopy
settings.rho0 = 1e-5;
settings.beta = 2;
settings.rhoMax = 10e6;

% Regularization homotopy
settings.sigma0 = 1;
settings.betaSigma = 1/10;
settings.sigmaMin = 1e-17;

% Complementarity tolerance
settings.complementarityTolerance = 1e-8;
settings.stationarityTolerance = 1e-7;

end