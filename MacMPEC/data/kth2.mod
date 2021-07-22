# kth2.mod
# 
# simple MPEC # 2

var z1 >= 0, := 1;
var z2 >= 0, := 0;

minimize objf: z1 + (z2 - 1)^2;

subject to 

   compl: 0 <= z1  complements  z2 >= 0;

