function [] = PlotAccuracy(problems)
%% Prepare data arrays
% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Store solver timings per problem
f = zeros(np, ns);
exit_flag = zeros(np, ns);

% Performance ratios (assume all problems solved with same solvers)
rf = zeros(np, ns);

% Store minimum time per problem
min_f_per_problem = inf(np,1);
max_f_per_problem = -inf(np,1);

%% Get the min&max solution time&obj for each problem
for p = 1:np
    problem = problems{p};
    for s = 1:ns
        solution = problem.solutions{s};
        
        f(p,s) = inf;
        exit_flag(p,s) = solution.stats.exit_flag;
        
        % Update mins and max if solved
        if (exit_flag(p,s) == 0)
            f(p,s) = solution.obj;
        
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

%% Get the performance ratio
for p = 1:np
    min_val = min_f_per_problem(p);
    max_val = max_f_per_problem(p);
    
    min_max_diff = max_val - min_val;
    
    for s = 1:ns                
        % Compute ratio (only if difference min max diff is large enough)
        if (min_max_diff > eps)
            rf(p,s) = 1 + (f(p,s) - min_val)/min_max_diff;
        else
            rf(p,s) = 1;    
        end
    end
end

%% Get the performance profile (of time)
% Then get the performance profile (of objective)
tauf = unique(sort(reshape(rf, np*ns, 1)));
rhof = zeros(length(tauf), ns);
for t = 1:length(tauf)
    for s = 1:ns
        rhof(t,s) = 1/np*length(find(rf(:,s) <= tauf(t)));
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

f = figure(2); 
for s=1:ns
    solver = problems{1}.solutions{s}.solver;
    
    plot( ...
        tauf, rhof(:,s),  ...
        'DisplayName', solver.name, ...
        'LineStyle', solver.lineStyle, ...
        'Color', cmap(col_indices(s),:) ...
    ); hold on; box on; grid on;
end
xlabel('$\tau$');
ylabel('$\bf{P}(p \in \mathcal{P} : f_{p,s} \leq \tau)$');
set(gca,'xscale','log');
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1.5);
legend('Location', 'southeast');

% Save as eps
exportgraphics(f,'/home/syscop/paper-lcqp-2/figures/benchmarks/MM_obj.pdf');
% 
% for s=1:ns
%     solver = problems{1}.solutions{s}.solver;
%     
%     figure; hold on; box on; grid on;
%     plot( ...
%         1:length(problems), exit_flag(:,s) ~= 0, ...
%         'DisplayName', solver.name, ...
%         'LineStyle', solver.lineStyle, ...
%         'Color', cmap(col_indices(s),:) ...
%     ); 
%     xlabel('$\mathrm{problem}$');
%     ylabel('$\mathrm{solved}$');
%     legend();
% end
end

