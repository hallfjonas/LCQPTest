# jr2.mod   QLR2-AN-LCP-2-1-1
#
# QPEC from ideas by Jiang & Ralph
#

var z1;
var z2 >= 0;

minimize objf: (z2 - 1)^2 + z1^2;

subject to 


   compl: 0 <= z2   complements   z2 - z1 >= 0;


