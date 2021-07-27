function [ problem ] = ReadData(datadir)

% Objective function
problem.Q = readmatrix(fullfile(datadir, 'H.txt'));
problem.g = readmatrix(fullfile(datadir, 'q.txt'));

% Complementarities
problem.L = readmatrix(fullfile(datadir, 'L.txt'));
problem.R = readmatrix(fullfile(datadir, 'R.txt'));
problem.lbL = readmatrix(fullfile(datadir, 'L_lb.txt'));
problem.ubL = readmatrix(fullfile(datadir, 'L_ub.txt'));
problem.lbR = readmatrix(fullfile(datadir, 'R_lb.txt'));
problem.ubR = readmatrix(fullfile(datadir, 'R_ub.txt'));

% Constraints
problem.A = readmatrix(fullfile(datadir, 'A.txt'));
problem.lbA = readmatrix(fullfile(datadir, 'b_lb.txt'));
problem.ubA = readmatrix(fullfile(datadir, 'b_ub.txt'));

% Box Constraints
problem.lb = readmatrix(fullfile(datadir, 'x_lb.txt'));
problem.ub = readmatrix(fullfile(datadir, 'x_ub.txt'));

problem.obj = @(x) 1/2*x'*problem.Q*x + problem.g'*x;

nv = size(problem.Q,1);
nc = size(problem.A,1);
ncomp = size(problem.L,1);

fprintf("Read LCQP of dimensions [nv, nc, ncomp] = [%d, %d, %d]\n", nv, nc, ncomp);

assert(all( size(problem.Q) == [nv, nv] ));
assert(all( size(problem.g) == [nv, 1] ));

assert(all( size(problem.L) == [ncomp, nv] ));
assert(all( size(problem.R) == [ncomp, nv] ));
assert(all( size(problem.lbL) == [ncomp, 1] ));
assert(all( size(problem.lbR) == [ncomp, 1] ));
assert(all( size(problem.ubL) == [ncomp, 1] ));
assert(all( size(problem.ubR) == [ncomp, 1] ));

assert(all( size(problem.A) == [nc, nv] ));
assert(all( size(problem.lbA) == [nc, 1] ));
assert(all( size(problem.ubA) == [nc, 1] ));

assert(all( size(problem.lb) == [nv, 1] ));
assert(all( size(problem.ub) == [nv, 1] ));
end