# kth1.mod
# 
# simple MPEC # 1

var z1 >= 0, := 0;
var z2 >= 0, := 1;

minimize objf: z1 + z2;

subject to 

   compl: 0 <= z1  complements  z2 >= 0;


