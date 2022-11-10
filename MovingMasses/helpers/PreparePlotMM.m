function [] = PreparePlotMM()

% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Want to change all linewidths?
set(findall(gcf, 'Type', 'Line'), 'LineWidth', 4);

% Increase font size
set(findall(gcf,'-property','FontSize'),'FontSize',13)

paperWidth = 3.5*0.97; paperHeight = 5;
set(gcf, 'paperunits', 'inches');
set(gcf, 'papersize', [paperWidth paperHeight]);
set(gcf, 'PaperPosition', [0 0 paperWidth paperHeight]);

end