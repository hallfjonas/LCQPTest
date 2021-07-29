function [] = PlotIterates(stats)

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

minObj = min(stats.objVals, eps);
minPhi = min(stats.phiVals, eps);
minMerit = min(stats.meritVals, eps);

iters_total = stats.iters_total;

figure; grid on; box on; 
yyaxis right;
plot(1:iters_total, stats.innerIters, 'DisplayName', 'inner iters'); hold on;
plot(1:iters_total, stats.subproblemIters, 'DisplayName', 'subproblem iters');
legend;

yyaxis left;
plot(1:iters_total, stats.accumulatedSubproblemIters, 'DisplayName', 'accumulated subproblem iters');
legend;
xlabel('$k$');

figure; grid on; box on;
plot(1:iters_total, stats.stepLength, 'DisplayName', '$\alpha_k$'); hold on;
plot(1:iters_total, stats.stepSize, 'DisplayName', '$\|p_k \|_\infty$');
set(gca,'yscale','log');
legend;
xlabel('$k$');

figure; grid on; box on;
plot(1:iters_total, stats.objVals - minObj, 'DisplayName', '$f(x_k)$'); hold on;
plot(1:iters_total, abs(stats.phiVals), 'DisplayName', '$\varphi(x_k)$');
plot(1:iters_total, stats.meritVals - minMerit, 'DisplayName', '$\psi(x_k)$');
% plot(1:iters_total, stats.statVals, 'DisplayName', '$\| \mathcal{L}(x_k) \|_\infty$');
set(gca,'yscale','log');
legend;
xlabel('$k$');

end