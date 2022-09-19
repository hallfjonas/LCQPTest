function[] = PlotLegend(problems)

leg1_lines = containers.Map;
leg2_lines = containers.Map;

ns = length(problems{1}.solutions);
for s=1:ns
    solver = problems{1}.solutions{s}.solver;
    
    leg1_lines(solver.style.label1) = plot(...
        [inf, inf], [inf, inf], ...
        'LineStyle', solver.style.linestyle, ...
        'Color', 'black', ...
        'LineWidth', 2.0 ...
    );

    leg2_lines(solver.style.label2) = fill(...
        [inf, inf], [inf, inf], ...
        solver.style.color, ...
        'EdgeColor', 'None' ...
    );
    
end

nms1 = []; 
lns1 = [];

nms2 = []; 
lns2 = [];

kys1 = keys(leg1_lines);
kys2 = keys(leg2_lines);

for key=1:length(kys1)
    nms1 = [nms1; string(kys1{key})];
    lns1 = [lns1; leg1_lines(kys1{key})];
end

for key=1:length(kys2)
    nms2 = [nms2; string(kys2{key})];
    lns2 = [lns2; leg2_lines(kys2{key})];
end

leg1 = legend(lns1, nms1, 'Location', 'SouthWest');
ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1, lns2, nms2, 'Location', 'SouthEast');

end