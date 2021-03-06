function [] = PlotTimings(problems)

timevals = [];
objvals = [];
complvals = [];
rho_opt_vals = [];
names = {};
colors = {};

for i = 1:length(problems)
    problem = problems{i};
    
    for j = 1:length(problem.solutions)
        solution = problem.solutions{j};
        
        timevals(i,j) = solution.stats.elapsed_time;
        complvals(i,j) = full(problem.casadi_formulation.Phi(solution.x));
        objvals(i,j) = full(problem.casadi_formulation.Obj(solution.x));
        rho_opt_vals(i,j) = solution.stats.rho_opt;
        output_flags(i,j) = min(solution.stats.exit_flag, 1);
        names{j} = solution.solver.name;
        colors{j} = solution.solver.color;
    end
end

%% Figure 2: Compare time, complementarity and objective values
figure; box on; grid on;

for j = 1:size(timevals,2)
    subplot(4,1,1);
    plot(1:size(timevals,1), timevals(:, j), 'DisplayName', names{j}, 'Color', colors{j}); hold on;
    set(gca,'yscale','log');
    title('Timings');
    legend();
    
    subplot(4,1,2);
    plot(1:size(objvals,1), objvals(:, j), 'DisplayName', names{j}, 'Color', colors{j}); hold on;
    title('Objective Value');
    legend();
    
    subplot(4,1,3);
    yyaxis right;
    plot(1:size(complvals,1), abs(complvals(:, j)), 'DisplayName', names{j}, 'Color', colors{j}); hold on;
    set(gca,'yscale','log');
    title('Complementarity violation');
    legend();
    
    yyaxis left;
    plot(1:size(complvals,1), output_flags, '--', 'DisplayName', ['outflag ', names{j}], 'Color', colors{j}); hold on;    
    
    subplot(4,1,4);
    plot(1:size(rho_opt_vals,1), rho_opt_vals(:, j), 'DisplayName', names{j}, 'Color', colors{j}); hold on;
    set(gca,'yscale','log');
    title('$\rho_\mathrm {opt}$');
    legend();
end
end