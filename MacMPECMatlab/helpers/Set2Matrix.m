function [ M ] = Set2Matrix( Set )

Scell = Set.getValues.toTable;
M = cell2mat(table2array(Scell));

end