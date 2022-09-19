function [] = PlotAccuracyIVOCP(problems, exp_name, outdir, compl_tolerance)

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
% Store solver objective per problem
f = zeros(np, ns);
phi = zeros(np, ns);
exit_flag = zeros(np, ns);

% Optimal solution vector according to homepage
x_ast = zeros(np,1);

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
        if (exit_flag(p,s) == 0 && solution.stats.compl < compl_tolerance)
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
fig = figure(30); hold on; grid on;
for s = 1:ns
    solver = problems{1}.solutions{s}.solver;
    plot(eps + f(:,s) + phi(:,s), ...
        'DisplayName', solver.style.label, ...
        'LineStyle', solver.style.linestyle, ...
        'Color', solver.style.color, ...
        'LineWidth', 2 ...
    )
end

% legend
legend('Location', 'northeast');

% yaxes
ylabel("$J(x) + \varphi(x)$")
set(gca, 'YScale', 'log')

% Save as pdf
exportgraphics(...
    fig, ...
    fullfile(outdir, [exp_name, '_obj_plus_phi.pdf']) ...
);

%% Complementarity Plot
fig = figure(11); hold on; grid on;

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
ylabel("$\varphi(x)$")

% Y-Log
set(gca, 'YScale', 'log')

% Save as pdf
exportgraphics(...
    fig, ...
    fullfile(outdir, [exp_name, '_compl.pdf']) ...
);
end

