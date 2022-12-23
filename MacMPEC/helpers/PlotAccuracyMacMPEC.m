function [] = PlotAccuracyMacMPEC(problems, exp_name, outdir, performance_metric)

% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

compl_tolerance = GetComplementaritySettings().complementarityTolerance;
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

            if (performance_metric == "abs_obj_dist_to_sol")
                % Issues:
                % 1) Finding better solutions is penalized
                % 2) Complementarity satisfaction is discregarded
                f(p,s) = abs(solution.stats.obj - x_ast(p));
            elseif (performance_metric == "cutoff")
                % Assuming that the complementarity tolerance is low enough
                % this should give a good metric for comparing objectives
                f(p,s) = max(0, solution.stats.obj - x_ast(p));
            elseif (performance_metric == "cutoff_penalized")
                % This metric compares both objective and complementarity
                % Remark that any feasible solution should satisfy 0-compl
                f(p,s) = max(0, solution.stats.obj - x_ast(p)) + abs(solution.stats.compl);
            else
                error("Not matching performance metric passed");
            end
        
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
figure('Visible','off'); hold on; grid on; box on;
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
set(gca,'xtick',1:np,'xticklabel',xtags, 'FontSize', 10);
xtickangle(90);

% Create the legend
% leg = legend('Location', 'northeast');

% Adapt y limits so that everything is visible
% ylim([eps/2, 10e9]);

% yaxes
ylab = ylabel("$\varepsilon_\mathrm{mach} + (J(x)-J(x^\ast))^+ + \varphi(x)$");
set(gca, 'YScale', 'log')

% Final polish
PreparePlot();

% Adapt xtick label font size
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',10);
% set(leg,'fontsize',18);
set(ylab,'fontsize',18);

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_obj_full.pdf']));

end

