function[ ] = PlotSolutionsMM(problem, exp_name, outdir)

% Problem data
nMasses = problem.nMasses;
N = problem.N;
T = problem.T;

% Grab indices
ind_x = problem.casadi_formulation.indices_x;
ind_u = problem.casadi_formulation.indices_u;
ind_z = problem.casadi_formulation.indices_z;
t = linspace(0, T, N+1);

for i = 1:nMasses
    ind_p(i,:) = ind_x(i:2*nMasses:end);
    ind_v(i,:) = ind_x(i+nMasses:2*nMasses:end);
    
    ind_y(i,:) = ind_z(i:3*nMasses:end);
    ind_lambda0(i,:) = ind_z(i + nMasses:3*nMasses:end);
    ind_lambda1(i,:) = ind_z(i + 2*nMasses:3*nMasses:end);
end

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Figure 1: Plot States
% Positions

% Colors
cmap = colormap(winter);
cmap = cmap(1:(size(cmap,1)-30), :);   % Remove v bright colors
col_indices = floor(linspace(1, size(cmap,1), nMasses));

% Plot the states of the first solution
i = 1;
solution = problem.solutions{i};   

% Complementarity switch line (manifold)
%subplot(2,1,1); hold on; box on; grid on; 
%plot( ...
%    t, zeros(size(t)), ...
%    ':k', 'DisplayName', 'Switch');


% First plot positions, velocities, controles
figure(62); box on; hold on; grid on;
for j = 1:nMasses
    % Positions
    plot(...
        t, solution.x(ind_p(j,:)), ...
        'LineStyle', '-', ...  
        'Color', cmap(col_indices(j),:), ...
        'DisplayName', ['$p_', num2str(j), '$'] ...
    );

    legend('Location', 'southeast', 'Orientation', 'horizontal');

    plot(...
        t, solution.x(ind_v(j,:)), ...
        'LineStyle', '--', ...     
        'Color', cmap(col_indices(j),:), ...
        'DisplayName', ['$v_', num2str(j), '$'] ...
    );

    xlabel('$t$');
    legend;
end

% Controls
yyaxis right
ax = gca;
ax.YColor = 'r';
stairs(...
    t(1:end), [solution.x(ind_u); NaN], ...
    'DisplayName', '$u$', ...
    'LineStyle', '-', ...
    'LineWidth', 2, ...
    'Color', "red" ...
);    
hold off;

% Plot legend
legend("Location", "northeast");

% Adjust limits
xlim([0,T]);
yyaxis left; ylim([-2,2]);
yyaxis right; ylim([-0.4, 0.4]);

% Update labels
xlabel("$\mathrm{time}$");
yyaxis left; ylabel("$\mathrm{states}$");
yyaxis right; ylabel("$\mathrm{controls}$");

% Final polish
PreparePlotMM(gca);

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_states.pdf']));

%% Plot complementarity variables
figure(63); box on; hold on; grid on;
for j = 1:nMasses
    plot(...
        t(2:end), solution.x(ind_lambda0(j,:)), ...
        'LineStyle', '--', ...
        'Color', cmap(col_indices(j),:)/2, ...
        'DisplayName', ['$\lambda^+_', num2str(j), '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_lambda1(j,:)), ...
        'LineStyle', '--', ...
        'Color', cmap(col_indices(j),:), ...
        'DisplayName', ['$\lambda^-_', num2str(j), '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_y(j,:)), ...
        'LineStyle', ':', ...
        'Color', cmap(col_indices(j),:), ...
        'DisplayName', ['$y_', num2str(j), '$'] ...
    );
end

% Legend
legend;

% Update range
xlim([0,T]);

% Update labels
xlabel("$\mathrm{time}$");
ylabel("$\mathrm{states}$");

% Final polish
PreparePlotMM(gca);

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_states_complementarities.pdf']));

end
