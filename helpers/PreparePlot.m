function [] = PreparePlot()

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Want to change all linewidths?
set(findall(gcf, 'Type', 'Line'), 'LineWidth', 2);

paperWidth = 7; paperHeight = 5;
set(gcf, 'paperunits', 'inches');
set(gcf, 'papersize', [paperWidth paperHeight]);
set(gcf, 'PaperPosition', [0 0 paperWidth paperHeight]);
set(gca,'FontSize',9)

end