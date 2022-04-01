function [ ] = PlotObjectivesMacMPEC(problems, exp_name, outdir)


% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Colors
cmap = colormap(parula);
cmap = cmap(1:(size(cmap,1)-30), :);   % Remove v bright colors
col_indices = floor(linspace(1, size(cmap,1), ns));

%% Prepare data arrays
% Store solver timings per problem
f = zeros(np, ns);
exit_flag = zeros(np, ns);

% Performance ratios (assume all problems solved with same solvers)
rf = zeros(np, ns);

% Optimal solution vector according to homepage
x_ast = zeros(np,1);
mean_obj_dist = inf(1,ns);

% Store minimum time per problem
min_f_per_problem = inf(np,1);
max_f_per_problem = -inf(np,1);

%% Get the min&max solution time&obj for each problem
for p = 1:np
    problem = problems{p};
    x_ast(p) = GetMacMPECOptimalObjective(problem.name);
    for s = 1:ns
        solution = problem.solutions{s};
        
        f(p,s) = inf;
        exit_flag(p,s) = solution.stats.exit_flag;
        
        % Update mins and max if solved
        if (exit_flag(p,s) == 0)
            f(p,s) = abs(solution.stats.obj - x_ast(p));
        
            % Update minimum objective
            if (f(p,s) < min_f_per_problem(p))
                min_f_per_problem(p) = f(p,s);
            end     
            
            % Update max obj
            if (f(p,s) > max_f_per_problem(p))
                max_f_per_problem(p) = f(p,s);
            end       
        end
    end
end

figure(10); hold on; grid on;

% Create bins
edges = 10.^(-16:1:ceil(log(max(f(~isinf(f))))));
nedges = length(edges);

% Count occurances per solver and bin (shift by eps)
counts = zeros(ns,nedges);
for s = 1:ns
    counts(s,:) = histc(eps+f(:,s), edges);
end

% Cummulate across each row
counts_col = cumsum(counts,2);

% Maybe extract representative columns?
e_max_diffs = zeros(nedges,1);
e_max_diffs(1) = max(counts_col(:,1));
for e = 2:nedges
    e_max_diffs(e) = max(counts_col(:,e) - counts_col(:,e-1));
end
rep_cols = find(e_max_diffs > 0);

% Plot the grouped bar plot
b = bar(counts_col(:, rep_cols)');

% axes
ylabel("Occurances")

% Generate x tags
xtags = [];
for i=1:length(rep_cols)
    xtags = [xtags, string(edges(rep_cols+1))];
end
set(gca,'xtick',1:length(rep_cols),'xticklabel',xtags);
xtickangle(45);

% Add legend
legendnames = [];
for s = 1:ns
    legendnames = [legendnames, string(problems{1}.solutions{s}.solver.name)];
end
legend(b, legendnames, 'Location', 'northwest');