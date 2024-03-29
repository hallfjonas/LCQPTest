
%% These paths may need adjustments
% Add path to the main solver
addpath("/opt/LCQPow");

% Add path to casadi (problems are built with this)
addpath("/opt/casadi");

% Add path to gurobi (some variants are solved with this
addpath("/opt/gurobi911/linux64/matlab");

% Add path to AMPL and set it up
addpath("/opt/ampl/ampl.linux-intel64/amplapi/matlab/");
setUp;

%% Local paths (no changes needed)
addpath("helpers/");
addpath("solvers/");
addpath("MacMPEC/");
addpath("MacMPEC/helpers/");
addpath("MacMPEC/MacMPECMatlab/");
addpath("IVOCP/");
addpath("IVOCP/helpers");
addpath("MovingMasses/");
addpath("MovingMasses/helpers");
