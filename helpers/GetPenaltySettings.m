function [settings] = GetPenaltySettings()

settings.rho0 = 10e-3;
settings.beta = 2;
settings.rhoMax = 10e10;
settings.complementarityTolerance = 1e-10;

end