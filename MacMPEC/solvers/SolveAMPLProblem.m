function [solution] = SolveAMPLProblem(name, solver)

% Create an AMPL instance
addpath("~/amplide.linux64/ampl.linux-intel64/amplapi/matlab");
setUp;
ampl = AMPL;

% Set solver
ampl.setOption('solver', solver);

% See if name needs adjustment
[modpath, datpath] = GetPaths(name);


% Read mod file
if (isfile(modpath))
    ampl.read(modpath);
end

% Read data file if exists
if (isfile(datpath))
    ampl.readData(datpath);
end

% Solve
tic;
ampl.solve

% Output stats
stats.elapsed_time = ampl.getValue('_total_solve_time');
stats.exit_flag = ampl.getValue('solve_result_num');
stats.obj = 0;

% Evaluate objective etc if possible
if (stats.exit_flag == 0)
    % Objective
    obj = ampl.getObjectives();
    if (obj.size == 0)
        disp('mhhhh')
    end

    f = obj(1);
    stats.obj = f.value;
end

% Solution struct
solution.stats = stats;

end