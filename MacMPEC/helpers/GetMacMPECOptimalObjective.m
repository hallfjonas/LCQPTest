function [ obj_ast ] = GetMacMPECOptimalObjective( name )
    
% Get Modpath
[~, ~, mac_name] = GetPaths(name);

% Read MacMPEC solutions
sols = readtable('MacMPECTable.csv');

for i = 1:length(sols.NAME)
    if (matches(mac_name, sols.NAME{i}))
        obj_ast = sols.solution(i);
        return;
    end
end

error("NO SOLUTION AVAILABLE")

end