function [variables] = LoadAMPLVariables( ampl )

% Load CasADi
addpath("~/casadi/");
import casadi.*;

varray = ampl.getVariables.toArray;
variables = containers.Map;

curIdxStart = 1;
for i = 1:length(varray)
    name = varray{i}.name;
    varstruct = {};
    
    varlen = varray{i}.numInstances;
    varstruct.var = SX.sym(name, varlen);
    curIdxEnd = curIdxStart+varlen;
    varstruct.indices = curIdxStart:curIdxEnd;
    varstruct.n = varlen;
    
    fprintf("Loading variable %s of length %d to caller workspace.\n", name, varlen);
    variables(name) = varstruct;    
    
    assignin('caller', name, varstruct.var);  
    
    curIdxStart = curIdxEnd + 1;
end

end

    