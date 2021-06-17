function [ M ] = Parameter2Matrix( Parameter )

if (Parameter.numInstances == 0)
    warning("Ignoring Parameter %s, as it contains no elements.\n", Parameter.name);
    M = [];
    return;
end

Pcell = Parameter.getValues.toTable;
Mtmp = cell2mat(table2array(Pcell));

% Some data uses indexing from 0, some start at one lol...
idx0 = 0;

if (size(Mtmp, 2) > 2)
    for k = 1:size(Mtmp, 1)
        i = Mtmp(k, 1);
        j = Mtmp(k, 2);
        val = Mtmp(k, 3);
        
        if (k == 1 && (i == 0 || j == 0))
            idx0 = 1;
        end
        
        M(i + idx0, j+idx0) = val;
    end
elseif (size(Mtmp,2) > 1)
    for k = 1:size(Mtmp, 1)
        i = Mtmp(k, 1);
        val = Mtmp(k, 2);
        
        if (k == 1 && i == 0)
            idx0 = 1;
        end
        
        M(i + idx0, 1) = val;
    end
else
    M = Mtmp;
end

end