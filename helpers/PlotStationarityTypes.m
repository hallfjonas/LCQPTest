function [] = PlotStationarityTypes(problems, exp_name, outdir)

% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

sol_types = zeros(np,1);
for k=1:np 
    if isfield(problems{k}.solutions{1}.stats, "solution_type")
        sol_types(k) = problems{k}.solutions{1}.stats.solution_type;
    end
end

%% Plot stat-types
figure('Visible','off'); hold on; grid on; box on;

plot(sol_types, ...
    'LineWidth', 2 ...
    )    

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
ylab = ylabel("$\mathrm{stationarity~types}$");

% Final polish
PreparePlot();

% Adapt xtick label font size
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',10);
% set(leg,'fontsize',18);
set(ylab,'fontsize',18);

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_stat_types.pdf']));

end

