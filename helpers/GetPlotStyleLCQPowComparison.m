function [ res ] = GetPlotStyleLCQPowComparison(solname)

    colors = distinguishable_colors(20);
    markers = {'o', '+', '*', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};
    linestyles = {'-','--',':','-.'};

    res = {};

    % First determine linestyle and first part of label
    if startsWith(solname, "SolveLCQPow0")
        res.markidx = 1;
        res.lsidx = 1;
        res.label1 = "qpOASES";
    elseif startsWith(solname, "SolveLCQPow1")
        res.markidx = 3;
        res.lsidx = 2;
        res.label1 = "qpOASES MA57";
    elseif startsWith(solname, "SolveLCQPow2")
        res.markidx = 2;
        res.lsidx = 3;
        res.label1 = "OSQP";
    else
        error("SOLVER STYLE FOR " + solname + " NOT YET SETUP!");
    end

    % Then determine color
    if endsWith(solname, "NoLeyffer")
        res.colidx = 20;
        res.label2 = "w/o Dyn Pen";
    elseif endsWith(solname, "SmallRho0")
        res.colidx = 6;
        res.label2 = "small $\rho_0$";
    elseif endsWith(solname, "LargeRho0")
        res.colidx = 18;
        res.label2 = "large $\rho_0$";
    elseif endsWith(solname, "SmallFast")
        res.colidx = 14;
        res.label2 = "small fast";
    elseif endsWith(solname, "SmallSlow")
        res.colidx = 15; 
        res.label2 = "small slow";
    elseif endsWith(solname, "NoZeroPen")
        res.colidx = 17;
        res.label2 = "w/o zero penalty";
    elseif endsWith(solname, "NoPerturbation")
        res.colidx = 9; 
        res.label2 = "w/o perturbation";
    elseif endsWith(solname, "LowComplementarity")
        res.colidx = 10; 
        res.label2 = "low complementarity";
    elseif endsWith(solname, "LowStationarity")
        res.colidx = 11; 
        res.label2 = "low stationarity";
    elseif endsWith(solname, "LowPrecision")
        res.colidx = 3; 
        res.label2 = "low precision";
    else
        res.colidx = 1; 
        res.label2 = "standard";
    end

    res.label = res.label1 + " " + res.label2;
    res.color = colors(res.colidx, :);
    res.marker = markers(res.markidx);
    res.linestyle = linestyles(res.lsidx);
end

