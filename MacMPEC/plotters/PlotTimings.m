function [] = PlotTimings(problems)

%% Prepare data arrays
% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Store solver timings per problem
t = zeros(np, ns);
exit_flag = zeros(np, ns);

% Performance ratios (assume all problems solved with same solvers)
rt = zeros(np, ns);

% Store minimum time per problem
min_t_per_problem = inf(np,1);
max_t_per_problem = -inf(np,1);

% Number of variables, constraints and complementarities
n_x = zeros(np, 1);
n_c = zeros(np, 1);
n_comp = zeros(np, 1);

%% Get the min&max solution time&obj for each problem
for p = 1:np
    problem = problems{p};
    for s = 1:ns
        solution = problem.solutions{s};
        
        t(p,s) = solution.stats.elapsed_time;
        exit_flag(p,s) = solution.stats.exit_flag;
        
        % Update mins and max if solved
        if (exit_flag(p,s) == 0)
            % Update minimum time
            if (t(p,s) < min_t_per_problem(p))
                min_t_per_problem(p) = t(p,s);
            end

            % Update maximum time        
            if (t(p,s) > max_t_per_problem(p))
                max_t_per_problem(p) = t(p,s);
            end
        end
        
        if (solution.solver.name == "LCQPow")
            n_x(p) = solution.stats.n_x;
            n_c(p) = solution.stats.n_c;
            n_comp(p) = solution.stats.n_comp;
        end
    end
end

fprintf(" range(n_x) = [%d %d]\n", min(n_x), max(n_x));
fprintf("  mean(n_x) = %f\n", mean(n_x));
fprintf("median(n_x) = %f\n\n", median(n_x));

fprintf(" range(n_c) = [%d %d]\n", min(n_c), max(n_c));
fprintf("  mean(n_c) = %f\n", mean(n_c));
fprintf("median(n_c) = %f\n\n", median(n_c));

fprintf(" range(n_comp) = [%d %d]\n", min(n_comp), max(n_comp));
fprintf("  mean(n_comp) = %f\n", mean(n_comp));
fprintf("median(n_comp) = %f\n\n", median(n_comp));

%% Get the performance ratio
for p = 1:np
    for s = 1:ns        
        % Failed solutions are set to max val
        if (exit_flag(p,s) ~= 0)
            t(p,s) = inf;
        end
                
        % Compute ratio
        rt(p,s) = t(p,s)/min_t_per_problem(p); 
    end
end

%% Get the performance profile (of time)
taut = unique(sort(reshape(rt, np*ns, 1)));
taut = taut( ~isinf(taut) );
rhot = zeros(length(taut), ns);
for t = 1:length(taut)
    for s = 1:ns
        rhot(t,s) = 1/np*length(find(rt(:,s) <= taut(t)));
    end
end

%% Create the plot
% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Colors
cmap = colormap(parula);
cmap = cmap(1:(size(cmap,1)-30), :);   % Remove v bright colors
col_indices = floor(linspace(1, size(cmap,1), ns));

f = figure(1); 
for s=1:ns
    solver = problems{1}.solutions{s}.solver;
    
    plot( ...
        taut, rhot(:,s),  ...
        'DisplayName', solver.name, ...
        'LineStyle', solver.lineStyle, ...
        'Color', cmap(col_indices(s),:) ...
    ); hold on; box on; grid on;
end
xlabel('$\tau$');
ylabel('$\bf{P}(p \in \mathcal{P} : r_{p,s} \leq \tau)$');
set(gca,'xscale','log');
xlim([1 taut(end)]);
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1.5);
legend('Location', 'southeast');

% Save as eps
exportgraphics(f,'/home/syscop/paper-lcqp-2/figures/benchmarks/MacMPEC_time.eps');

end

