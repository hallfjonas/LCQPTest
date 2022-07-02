function [ res ] = GetPlotStyle(solname)

    colors = distinguishable_colors(20);
    markers = {'o', '+', '*', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};
    linestyles = {'-','--','-.',':'};

    res = {};

    if solname == "SolveLCQPow_qpOASES"
        res.colidx = 1;
        res.markidx = 1;
        res.lsidx = 1;
        res.label = "LCQPow qpOASES";
    elseif solname == "SolveLCQPow_OSQP"
        res.colidx = 8;
        res.markidx = 2;
        res.lsidx = 1;
        res.label = "LCQPow OSQP";
    elseif solname == "SolveLCQPow_qpOASES_sparse"
        res.colidx = 1;
        res.markidx = 3;
        res.lsidx = 1;
        res.label = "LCQPow qoOASES MA57";
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
    elseif solname == "SolveNLP"
        res.colidx = 10;
        res.markidx = 6;
        res.lsidx = 3;
        res.label = "IPOPT NLP";
    elseif solname == "SolveSNOPT"
        res.colidx = 5;
        res.markidx = 7;
        res.lsidx = 4;
        res.label = "SNOPT";
    elseif solname == "SolveMINOS"
        res.colidx = 15;
        res.markidx = 8;
        res.lsidx = 4;
        res.label = "MINOS";
    else
        error("SOLVER STYLE FOR " + solname + " NOT YET SETUP!");
    end

    res.color = colors(res.colidx, :);
    res.marker = markers(res.markidx);
    res.linestyle = linestyles(res.lsidx);
end

