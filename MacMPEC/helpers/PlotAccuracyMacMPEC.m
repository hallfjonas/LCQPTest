function [] = PlotAccuracyMacMPEC(problems, exp_name, outdir, compl_tolerance)

% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

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
    x_ast(p) = GetMacMPECOptimalObjective(problem.name);
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
            % f(p,s) = abs(solution.stats.obj - x_ast(p));
            f(p,s) = max(0, solution.stats.obj - x_ast(p)) + abs(solution.stats.compl);
        
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
fig = figure(3); hold on; grid on;
for s = 1:ns
    solver = problems{1}.solutions{s}.solver;
    plot(eps + f(:,s), ...
        'DisplayName', solver.style.label, ...
        'LineStyle', solver.style.linestyle, ...
        'Color', solver.style.color, ...
        'LineWidth', 2 ...
    )    
end

% Write names of problems on x axis
xtags = strings(np,1);
for p = 1:np
    pname = string(strrep(problems{p}.name,'_',' '));
    xtags(p) = pname;
end
legend('Location', 'northeast');
set(gca,'xtick',1:np,'xticklabel',xtags);
xtickangle(90);

% yaxes
ylabel("$\varepsilon_\mathrm{mach} + (J(x)-J(x^\ast))^+ + \varphi(x)$")
set(gca, 'YScale', 'log')

% Save as pdf
exportgraphics(...
    fig, ...
    fullfile(outdir, [exp_name, '_obj_full.pdf']) ...
);

%% Generate a obj-val comparison plot
%fig = figure(30); hold on; grid on;
%for s = 1:ns
%    solver = problems{1}.solutions{s}.solver;
%    plot(eps + f(:,s) + phi(:,s), ...
%        'DisplayName', solver.style.label, ...
%        'LineStyle', solver.style.linestyle, ...
%        'Color', solver.style.color, ...
%        'LineWidth', 2 ...
%    )    
%end

%% Write names of problems on x axis
%xtags = strings(np,1);
%for p = 1:np
%    pname = string(strrep(problems{p}.name,'_',' '));
%    xtags(p) = pname;
%end
%legend('Location', 'northeast');
%set(gca,'xtick',1:np,'xticklabel',xtags);
%xtickangle(90);

%% yaxes
%ylabel("$J(x) + \varphi(x)$")
%set(gca, 'YScale', 'log')

%% Save as pdf
%exportgraphics(...
%    fig, ...
%    fullfile(outdir, [exp_name, '_obj_plus_phi.pdf']) ...
%);

%% Create bar plot 
fig = figure(10); hold on; grid on;

% Create bins
edges = 10.^(-16:2:ceil(log(max(f(~isinf(f))))));
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
xlabel("$\varepsilon$");
ylabel("$\# \{ (J(x) - J(x^\ast))^+ + \varphi(x) \leq \varepsilon \} $");

% Generate x tags
xtags = string(edges(rep_cols+1));
set(gca,'xtick',1:length(rep_cols),'xticklabel',xtags);
xtickangle(90);

% Add legend
legendnames = strings(ns,1);
for s = 1:ns
    legendnames(s) = string(problems{1}.solutions{s}.solver.style.label);
    b(s).FaceColor = problems{1}.solutions{s}.solver.style.color;
end
legend(b, legendnames, 'Location', 'northwest');


% Save as pdf
exportgraphics(...
    fig, ...
    fullfile(outdir, [exp_name, '_obj_bar.pdf']) ...
);

%% Complementarity Plot
fig = figure(11); hold on; grid on;

% Show the unsuccessful area
y0 = 10e-17;
y1 = compl_tolerance;
y2 = 10e7;
fill([1, 1, np, np],[y1 y0 y0 y1],'g', 'FaceAlpha', 0.1, 'EdgeAlpha', 0.0);
fill([1, 1, np, np],[y2 y1 y1 y2],'r', 'FaceAlpha', 0.1, 'EdgeAlpha', 0.0);

xlim([1, np]);
ylim([y0, y2]);

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
legend(lines, names, 'Location', 'northwest');

% axes
ylabel("Complementarity")

% Write names of problems on x axis
xtags = [];
for p = 1:np
    pname = string(strrep(problems{p}.name,'_',' '));
    xtags = [xtags, pname];
end
legend('Location', 'northeast');
set(gca, 'YScale', 'log')
set(gca,'xtick',1:np,'xticklabel',xtags);
xtickangle(90);

% Y-Log
set(gca, 'YScale', 'log')

% Save as pdf
exportgraphics(...
    fig, ...
    fullfile(outdir, [exp_name, '_compl.pdf']) ...
);
end

