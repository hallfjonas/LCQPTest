function [] = CreateIVOCPPlots(outdir)

% Warnings: serializing casadi objects not supported, that's OK
solutionFile = fullfile(outdir, "sol.mat");
if ~isfile(solutionFile)
    error("File " + solutionFile + " does not exist");
end

load(solutionFile, "benchmark");

% Get the solver visualization settings and add them to the struct
for s=1:length(benchmark.solvers)
    for p=1:length(benchmark.problems)
        benchmark.problems{p}.solutions{s}.solver.style = GetPlotStyle(benchmark.problems{p}.solutions{s}.solver.fun);
    end
end

% Create the plots
PlotTimings(benchmark.problems, 'IVOCP', outdir);
PlotAccuracyIVOCP(benchmark.problems, 'IVOCP', outdir);

end
