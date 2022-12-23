function [] = PlotTimings(problems, exp_name, outdir)

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

% Get complementarity tolerance
compl_tol = GetComplementaritySettings().complementarityTolerance;

%% Get the min&max solution time&obj for each problem
for p = 1:np
    problem = problems{p};
    for s = 1:ns
        solution = problem.solutions{s};
        t(p,s) = solution.stats.elapsed_time_w_overhead;
        exit_flag(p,s) = solution.stats.exit_flag;
        
        % Update mins and max if solved
        if (solution.stats.compl < compl_tol)
            % Update minimum time
            if (t(p,s) < min_t_per_problem(p))
                min_t_per_problem(p) = t(p,s);
            end

            % Update maximum time        
            if (t(p,s) > max_t_per_problem(p))
                max_t_per_problem(p) = t(p,s);
            end
        end
    end
end

%% Get the performance ratio
for p = 1:np
    problem = problems{p};
    for s = 1:ns        
        solution = problem.solutions{s};
        
        % Failed solutions are set to max val
        if (solution.stats.compl >= compl_tol)
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
figure(100,'Visible','off'); 
for s=1:ns
    solver = problems{1}.solutions{s}.solver;
    
    plot( ...
        taut, rhot(:,s),  ...
        ... %'DisplayName', solver.style.label, ...
        'LineStyle', solver.style.linestyle, ...
        'DisplayName', solver.style.label, ...
        'Color', solver.style.color, ...
        'LineWidth', 2.0 ...
    ); hold on; box on; grid on;
end
xlabel('$\tau$');
ylabel('$\bf{P}(p \in \mathcal{P} : r_{p,s} \leq \tau)$');
xticks([1, 10, 100, 1000, 10000]);
set(gca,'xscale','log');
xlim([1, 10000]);

% Legend
legend('Location', 'southeast');

% Final polish
PreparePlot();

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_time_w_overhead.pdf']));

end

