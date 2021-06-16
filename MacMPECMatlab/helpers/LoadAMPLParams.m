function [amplParameters] = LoadAMPLParams( ampl )

amplParameters = containers.Map;
parray = ampl.getParameters.toArray;

for i = 1:length(parray)
    key = parray{i}.name;
    val = Parameter2Matrix(parray{i});
    
    fprintf("Loaded parameter %s of size (%d, %d).\n", key, size(val,1), size(val,2));
    
    amplParameters(key) = val;    
end

end

    