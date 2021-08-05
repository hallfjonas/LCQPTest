function[ ] = PlotSolutions(problem)

% Problem data
nMasses = problem.nMasses;
N = problem.N;
T = problem.T;
h = T/N;

% Grab indices
ind_x = problem.casadi_formulation.indices_x;
ind_u = problem.casadi_formulation.indices_u;
ind_z = problem.casadi_formulation.indices_z;
x0    = problem.casadi_formulation.x0;

t = linspace(0, T, N+1);

for i = 1:nMasses
    ind_p(i,:) = ind_x(i:2*nMasses:end);
    ind_v(i,:) = ind_x(i+nMasses:2*nMasses:end);
    
    ind_y(i,:) = ind_z(i:3*nMasses:end);
    ind_lambda0(i,:) = ind_z(i + nMasses:3*nMasses:end);
    ind_lambda1(i,:) = ind_z(i + 2*nMasses:3*nMasses:end);
end

% Line specifications
linestyle = { '-', '--', ':', '-.', '-', '--', ':', '-.'};
% marker = { 'o', '+', 's', 'd', 'v', '>' };

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Figure 1: Plot States
% Positions

f = figure(1);

% Colors
cmap = colormap(winter);
cmap = cmap(1:(size(cmap,1)-30), :);   % Remove v bright colors
col_indices = floor(linspace(1, size(cmap,1), nMasses));

for i = 1:length(problem.solutions)
    solution = problem.solutions{i};   
    
    if (solution.solver.name ~= "LCQPow")
        continue;
    end
    
    % Controls
    subplot(3,1,2); hold on; box on; grid on; 
    stairs(...
        t(1:end-1), solution.x(ind_u), ...
        'DisplayName', '$u$', ...
        'LineWidth',1.5 ...
    );    
    legend;
    xlim([0,T]);
    
    % Complementarity switch line (manifold)
    %subplot(3,1,1); hold on; box on; grid on; 
    %plot( ...
    %    t, zeros(size(t)), ...
    %    ':k', 'DisplayName', 'Switch');
    
    for j = 1:nMasses
        % Positions
        subplot(3,1,1); hold on; box on; grid on;
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
        legend;
        
        subplot(3,1,3); hold on; box on; grid on;     
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
        legend;
        xlim([0,T]);
    end
end
subplot(3,1,1);
set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);

subplot(3,1,3);
set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);

% Save as pdf
exportgraphics(f,'/home/syscop/paper-lcqp-2/figures/benchmarks/MovingMasses_Trajectory.pdf');

end
