function [] = LoadAMPLParams( ampl )

parray = ampl.getParameters.toArray;

for i = 1:length(parray)
    name = parray{i}.name;
    val = Parameter2Matrix(parray{i});
    
    fprintf("Loading parameter %s of size (%d, %d) to caller workspace.\n", name, size(val,1), size(val,2));
    assignin('caller', name, val);  
end

end
