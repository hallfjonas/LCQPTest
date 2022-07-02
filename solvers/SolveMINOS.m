function [solution] = SolveMINOS(casadi_formulation)

solution = SolveAMPL(casadi_formulation, 'minos');

end


