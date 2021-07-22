# kth3.mod
# 
# simple MPEC # 3

var z1 >= 0, := 1;
var z2 >= 0, := 1;

minimize objf: 0.5*(z1 - 1)^2 + (z2 - 1)^2;

subject to 

   compl: 0 <= z1  complements  z2 >= 0;

