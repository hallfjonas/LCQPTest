function [ M ] = Parameter2Matrix( Parameter )

Pcell = Parameter.getValues.toTable;
Mtmp = cell2mat(table2array(Pcell));

if (size(Mtmp, 2) > 2)
    for k = 1:size(Mtmp, 1)
        i = Mtmp(k, 1);
        j = Mtmp(k, 2);
        val = Mtmp(k, 3);
        M(i,j) = val;
    end
elseif (size(Mtmp,2) > 1)
    for k = 1:size(Mtmp, 1)
        i = Mtmp(k, 1);
        val = Mtmp(k, 2);
        M(i, 1) = val;
    end
elseif (size(Mtmp,1) == 1)
    M = Mtmp;
else
    error("Unknown parameter dimension...\n");
end

end