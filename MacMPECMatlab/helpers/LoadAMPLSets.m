function [] = LoadAMPLSets( ampl )

sarray = ampl.getSets.toArray;

for i = 1:length(sarray)
    name = sarray{i}.name;
    val = Set2Matrix(sarray{i});
    
    fprintf("Loading set %s of size (%d, %d) to caller workspace.\n", name, size(val,1), size(val,2));
    assignin('caller', name, val);  
end

end
