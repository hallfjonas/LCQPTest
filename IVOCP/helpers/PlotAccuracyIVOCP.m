function [] = PlotAccuracyIVOCP(problems, exp_name, outdir, comp_tol)

% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

%% Prepare data arrays
% Store solver objective per problem
f = zeros(np, ns);
phi = zeros(np, ns);
exit_flag = zeros(np, ns);

% Store minimum time per problem
min_f_per_problem = inf(np,1);
max_f_per_problem = -inf(np,1);

%% Get the min&max solution time&obj for each problem
for p = 1:np
    problem = problems{p};
    for s = 1:ns
        solution = problem.solutions{s};
        
        f(p,s) = inf;
        phi(p,s) = inf;
        exit_flag(p,s) = solution.stats.exit_flag;
        
        % Store the complementarity whenever solver succeeded
        if (exit_flag(p,s) == 0)
            phi(p,s) = max(0, solution.stats.compl);
        end

        % Update mins and max if solved
        if (exit_flag(p,s) == 0 && solution.stats.compl < comp_tol)
            % The objective already compares to analytical solution
            f(p,s) = solution.stats.obj;
        
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

%% Generate a obj-val comparison plot
figure(30); hold on; box on;

min_y = inf;
lines = gobjects(ns,1); names = strings(ns,1);

for s = 1:ns
    solver = problems{1}.solutions{s}.solver;
    l = plot(f(:,s), ...
        'DisplayName', solver.style.label, ...
        'LineStyle', solver.style.linestyle, ...
        'Color', solver.style.color, ...
        'LineWidth', 2 ...
    );

    lines(s) = l;
    names(s) = string(solver.style.label);
    
    min_y = min(min_y, min(f(:,s) + phi(:,s)));
end

% Grid
set(gca, 'YGrid', 'on', 'XGrid', 'off');

% limits
ylim([min_y, 2.0]);
xlim([1, np]);

% Do annotation
xN_start = 1; xN_end = 2;
for p = 2:np
    if problems{p-1}.N ~= problems{p}.N
        xN_end = p-1;
        xline(p-1, 'Color', 'black', 'Alpha', 0.2, 'LineWidth', 2);
        xN_start = p;
    end
end

% legend
legend(lines, names, 'Location', 'northeast');

% axes
ylabel("$J$");
xlabel("experiment number");
set(gca, 'YScale', 'log');

% Final polish
PreparePlot(gca);

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_obj_plus_phi.pdf']));

%% Complementarity Plot
figure(11); hold on; grid on; box on;

% Show the unsuccessful area
yMin = 10e-17;
yMax = 10e-8;

xlim([1, np]);
ylim([yMin, yMax]);

% Plot the complementarity violations
lines = gobjects(ns,1); names = strings(ns,1);
for s = 1:ns
    solver = problems{1}.solutions{s}.solver;
    l = plot( ...
        1:np, ...
        eps + abs(phi(:,s)), ...
        'LineStyle', solver.style.linestyle, ...
        'Color', solver.style.color, ...
        'LineWidth', 2 ...
    );
    lines(s) = l;
    names(s) = string(solver.style.label);
end

% legend
legend(lines, names, 'Location', 'northwest');

% axes
ylabel("$\varphi$")

% Y-Log
set(gca, 'YScale', 'log')

% Final polish
PreparePlot(gca);

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_compl.pdf']));

end

