function [ res ] = GetPlotStyle(solname)

    colors = distinguishable_colors(20);
    markers = {'o', '+', '*', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};
    linestyles = {'-','--',':','-.'};

    % Plot colors for choosing
    %figure; hold on;
    %for i = 1:20
    %    xline(i, 'Color', colors(i,:), 'LineWidth', 5);
    %end

    res = {};

    if solname == "SolveLCQPow0"
        res.colidx = 1;
        res.markidx = 1;
        res.lsidx = 1;
        res.label = "LCQPow qpOASES";
    elseif solname == "SolveLCQPow1"
        res.colidx = 1;
        res.markidx = 3;
        res.lsidx = 1;
        res.label = "LCQPow qoOASES MA57";
    elseif solname == "SolveLCQPow2"
        res.colidx = 8;
        res.markidx = 2;
        res.lsidx = 4;
        res.label = "LCQPow OSQP";
    elseif solname == "SolveMIQP"
        res.colidx = 2;
        res.markidx = 4;
        res.lsidx = 2;
        res.label = "Gurobi";
    elseif solname == "SolveIPOPTPen"
        res.colidx = 3;
        res.markidx = 5;
        res.lsidx = 3;
        res.label = "IPOPT Pen";
    elseif solname == "SolveIPOPTNLP"
        res.colidx = 20;
        res.markidx = 6;
        res.lsidx = 3;
        res.label = "IPOPT NLP";
    elseif solname == "SolveIPOPTReg"
        res.colidx = 10;
        res.markidx = 7;
        res.lsidx = 3;
        res.label = "IPOPT Reg";
    elseif solname == "SolveIPOPTRegEq"
        res.colidx = 11;
        res.markidx = 8;
        res.lsidx = 3;
        res.label = "IPOPT Smoothed";
    else
        error("SOLVER STYLE FOR " + solname + " NOT YET SETUP!");
    end

    res.color = colors(res.colidx, :);
    res.marker = markers(res.markidx);
    res.linestyle = linestyles(res.lsidx);
end

