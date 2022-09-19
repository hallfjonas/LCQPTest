close all; clear all; clc;

ncols = 20;
cmap = distinguishable_colors(ncols);

figure; hold on; 

for i=1:ncols
    plot([i, i], [0, 1], color=cmap(i,:), LineWidth=5);
end

