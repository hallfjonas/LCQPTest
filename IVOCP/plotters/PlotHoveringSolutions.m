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

t = linspace(0, T, N+1);

for i = 1:nMasses
    ind_p(i,:) = ind_x(i:2*nMasses:end);
    ind_v(i,:) = ind_x(i+nMasses:2*nMasses:end);
end
ind_y = ind_z(1:4:end);
ind_lambda0 = ind_z(2:4:end);
ind_lambda1 = ind_z(3:4:end);

% Line specifications
linestyle = { '-', '--', ':', '-.', '-', '--', ':', '-.'};
% marker = { 'o', '+', 's', 'd', 'v', '>' };

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Figure 1: Plot States
figure;

% Positions
for i = 1:length(problem.solutions)
    solution = problem.solutions{i};    
    
    % Controls
    subplot(2,1,1); hold on; box on; grid on; 
    yyaxis right;
    stairs(...
        t(1:end-1), solution.x(ind_u), ...
        'Color', solution.solver.color ...
    );    
    xlim([0,T]);
    
    % Complementarity switch line (manifold)
    subplot(2,1,2); hold on; box on; grid on;
    plot(t, zeros(size(t)), '-k');
    
    plot(...
        t, solution.x(ind_v(nMasses,:)), ...
        'LineStyle', linestyle{nMasses}, ...     
        'Color', solution.solver.color, ...
        'DisplayName', ['$v_', num2str(nMasses), '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_lambda0(:)), ...
        'LineStyle', linestyle{nMasses}, ...
        'Color', 'cyan', ...
        'DisplayName', ['$\lambda^+', '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_lambda1(:)), ...
        'LineStyle', linestyle{nMasses}, ...
        'Color', 'cyan', ...
        'DisplayName', ['$\lambda^-', '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_y(:)), ...
        'LineStyle', linestyle{nMasses}, ...
        'Color', 0.5*[1 1 0] + 0.5*[1 0 0], ...
        'DisplayName', ['$y', '$'] ...
    );
    legend;
    xlim([0,T]);
    
    for j = 1:nMasses
        % Positions
        subplot(2,1,1); hold on; box on; grid on;
        yyaxis left;
        plot(...
            t, solution.x(ind_p(j,:)), ...
            'LineStyle', linestyle{j}, ...     
            'Color', solution.solver.color ...
        );
    end
end

end
