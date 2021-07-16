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
    ind_y(i,:) = ind_z(i:4*nMasses:end);
    ind_lambda0(i,:) = ind_z(i+1*nMasses:4*nMasses:end);
    ind_lambda1(i,:) = ind_z(i+2*nMasses:4*nMasses:end);
    ind_l(i,:) = ind_z(i+3*nMasses:4*nMasses:end);
end

% Line specifications
linestyle = { '-', '--', ':', '-.', '-', '--', ':', '-.'};
% marker = { 'o', '+', 's', 'd', 'v', '>' };

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Figure 1: Plot States
figure(1);

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
    
    for j = 1:nMasses
        % Positions
        subplot(2,1,1); hold on; box on; grid on;
        yyaxis left;
        plot(...
            t, solution.x(ind_p(j,:)), ...
            'LineStyle', linestyle{j}, ...     
            'Color', solution.solver.color ...
        );       

        % Velocities and Complementarity
        subplot(2,1,2); hold on; box on; grid on;

        plot(...
            t, solution.x(ind_v(j,:)), ...
            'LineStyle', linestyle{j}, ...     
            'Color', solution.solver.color, ...
            'DisplayName', ['$v_', num2str(j), '$'] ...
        );
        plot(t, zeros(size(t)), '-k');
        
        plot(...
            t(2:end), solution.x(ind_lambda0(j,:)), ...
            'LineStyle', linestyle{j}, ...
            'Color', 'cyan', ...
            'DisplayName', ['$\lambda^+_', num2str(j), '$'] ...
        );
    
        plot(...
            t(2:end), solution.x(ind_lambda1(j,:)), ...
            'LineStyle', linestyle{j}, ...
            'Color', 'cyan', ...
            'DisplayName', ['$\lambda^-_', num2str(j), '$'] ...
        );
    
        plot(...
            t(2:end), solution.x(ind_y(j,:)), ...
            'LineStyle', linestyle{j}, ...
            'Color', 0.5*[1 1 0] + 0.5*[1 0 0], ...
            'DisplayName', ['$y_', num2str(j), '$'] ...
        );
        legend;
        xlim([0,T]);
    end
end

end
