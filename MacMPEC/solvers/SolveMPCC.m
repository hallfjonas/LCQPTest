function [solution] = SolveMPCC(name)

import casadi.*;

addpath("~/LCQPow/build/lib");
currdir = pwd;
cd MacMPECMatlab/;
run([name, '.m']);
cd(currdir);

df = DataFrame(1, 'A', 'c');
for i = 1:1000
    df.addRow(i, i * 1.1);
end

addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab");
setUp;
ampl = AMPL;

% Assign index sets
ampl.eval(sprintf("set N = 1..%d;", problem.nV));
ampl.eval(sprintf("set M = 1..%d;", problem.nC));
ampl.eval(sprintf("set L = 1..%d;", problem.nComp));

% Optimization variable
ampl.eval('var x{i in N};');

% TODO: Model objective and constraints (including box, linear, compl)
% TODO: Then evaluate objective, complementarity and timings ...
end
