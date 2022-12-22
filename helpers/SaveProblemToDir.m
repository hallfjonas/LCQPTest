function [] = SaveProblemToDir(problem, outdir)

if (isfield(problem, "Q"))
    SaveMatrixToFile(problem.Q, fullfile(outdir, "Q.txt"))
end

if (isfield(problem, "g"))
    SaveMatrixToFile(problem.g, fullfile(outdir, "g.txt"))
end

if (isfield(problem, "L"))
    SaveMatrixToFile(problem.L, fullfile(outdir, "L.txt"))
end

if (isfield(problem, "R"))
    SaveMatrixToFile(problem.R, fullfile(outdir, "R.txt"))
end

if (isfield(problem, "lbL"))
    SaveMatrixToFile(problem.lbL, fullfile(outdir, "lbL.txt"))
end

if (isfield(problem, "lbR"))
    SaveMatrixToFile(problem.lbR, fullfile(outdir, "lbR.txt"))
end

if (isfield(problem, "ubL"))
    SaveMatrixToFile(problem.ubL, fullfile(outdir, "ubL.txt"))
end

if (isfield(problem, "ubR"))
    SaveMatrixToFile(problem.ubR, fullfile(outdir, "ubR.txt"))
end

if (isfield(problem, "A"))
    SaveMatrixToFile(problem.A, fullfile(outdir, "A.txt"))
end

if (isfield(problem, "lbA"))
    SaveMatrixToFile(problem.lbA, fullfile(outdir, "lbA.txt"))
end

if (isfield(problem, "ubA"))
    SaveMatrixToFile(problem.ubA, fullfile(outdir, "ubA.txt"))
end

if (isfield(problem, "lb") && ~isempty(problem.lb))
    SaveMatrixToFile(problem.lb, fullfile(outdir, "lb.txt"))
end

if (isfield(problem, "ub") && ~isempty(problem.ub))
    SaveMatrixToFile(problem.ub, fullfile(outdir, "ub.txt"))
end

end

% Export matrix to txt file (row-wise)
function [] = SaveMatrixToFile(M, outfile)
M_top = M';
writematrix(M_top(:), outfile);
end