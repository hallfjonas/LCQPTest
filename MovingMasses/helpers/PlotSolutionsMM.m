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

%% Figure 1: Plot States
% Plot the states of the first solution
i = 1;
solution = problem.solutions{i};   

% Complementarity switch line (manifold)
%subplot(2,1,1); hold on; box on; grid on; 
%plot( ...
%    t, zeros(size(t)), ...
%    ':k', 'DisplayName', 'Switch');

% First plot positions, velocities, controles
figure(62,'Visible','off'); box on; hold on; grid on;
C = linspecer(nMasses+1);
linestyles = ["-", "--", ":", "-."];
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');

% Position plot
ax1 = nexttile; hold on; box on;
xlim([0,T]);
ylim([-1.5,1.5]);
set(gca,'Xticklabel',[]);
legend('Location', 'northeast', 'Orientation', 'horizontal');

% Velocity plot
ax2 = nexttile; hold on; box on;
xlim([0,T]);
ylim([-1.5,1.5]);
set(gca,'Xticklabel',[]);
legend('Location', 'northeast', 'Orientation', 'horizontal');

% Control plot
ax3 = nexttile; hold on; box on;
xlim([0,T]);    
ylim([-1.5,1.5]);
xlabel("$\mathrm{time}$");
legend('Location', 'northeast', 'Orientation', 'horizontal');
for j = 1:nMasses
    
    % Positions
    plot(...
        ax1, ...
        t, solution.x(ind_p(j,:)), ...
        'LineStyle', linestyles(j), ...  
        'Color', C(j,:), ...
        'DisplayName', ['$p_', num2str(j), '$'] ...
    );

    plot(...
        ax2, ...
        t, solution.x(ind_v(j,:)), ...
        'LineStyle', linestyles(j), ...     
        'Color', C(j,:), ...
        'DisplayName', ['$v_', num2str(j), '$'] ...
    );
end

% Controls
stairs(...
    ax3, ...
    t(1:end), [solution.x(ind_u); NaN], ...
    'DisplayName', '$u$', ...
    'LineStyle', '-', ...
    'LineWidth', 2, ...
    'Color', C(end,:) ...
);

% Final polish
PreparePlotMM();

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_states.pdf']));
exportgraphics(gcf, fullfile(outdir, [exp_name, '_states.png']), 'Resolution',GetResolution());

%% Plot complementarity variables

C = linspecer(nMasses);
linestyles = ["--", ":", "-"];

figure(63,'Visible','off'); box on; hold on; grid on;
tlo = tiledlayout(nMasses,1,'TileSpacing','none','Padding','none');
for j = 1:nMasses
    nexttile; hold on; box on;
    % Remove x tick labels from all subplots but lowest
    if j < nMasses
        set(gca,'Xticklabel',[]); 
    end

    % Otherwise box is not printed lol
    if j == 1
        ylim([0,1.5]);
    else
        ylim([0,1.49]);
    end

    plot(...
        t(2:end), solution.x(ind_lambda0(j,:)), ...
        'LineStyle', linestyles(1), ...
        'Color', C(j,:), ...
        'DisplayName', ['$\lambda^+_', num2str(j), '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_lambda1(j,:)), ...
        'LineStyle', linestyles(2), ...
        'Color', C(j,:), ...
        'DisplayName', ['$\lambda^-_', num2str(j), '$'] ...
    );

    plot(...
        t(2:end), solution.x(ind_y(j,:)), ...
        'LineStyle', linestyles(3), ...
        'Color', C(j,:), ...
        'DisplayName', ['$y_', num2str(j), '$'] ...
    );
    
    % Legend
    legend(Location="northeast");
end


% Update range
xlim([0,T]);

% Update labels
xlabel("$\mathrm{time}$");
% ylabel("$\mathrm{states}$");

% Final polish
PreparePlotMM();

% Export
print(gcf, '-dpdf', fullfile(outdir, [exp_name, '_states_complementarities.pdf']));
exportgraphics(gcf, fullfile(outdir, [exp_name, '_states_complementarities.png']), 'Resolution',GetResolution());


end
