#################################################################
#                                  				#
#  October/2005                                        		#
#                                               		#
#  This problem is described in "Strategic Gaming Analysis      #
#  for Electric Power Systems: an MPEC Approach",               #
#  by Benjamin F. Hobbs, Carolyn Metzler and Jong Shi-Pang  	#
#								#
#  Coded by Helena Rodrigues and Teresa Monteiro                #
#################################################################



# SETS ------------------------------------------------------
set N;          		# set of all nodes
set A in N cross N; 		# set of all arcs
set Sf;         		# set of nodes with generators under control firm A
set P;          		# set of all generator nodes
set D;          		# set of all demand nodes
set L;          		# set of Kirchhoff's voltage loops

# PARAMETERS --------------------------------------------------
param a{P};             	# intercept of supply function
param b{P};             	# slope of supply funtion
param c{D};             	# intercept of demand function 
param d{D};             	# slope of demand function
param alfa_s{P};        	# upper bound of the bid 
param alfa_i{P};        	# lower bound of the bid 
param QS_s{P};          	# upper bound of production capacity 
param Ts{A};            	# maximum transmission capacity on arc ij
param RR{L, A} default 0;  	# matrix of signed reactance coefficients
param RRT{A,L} default 0;	# transpose matrix
param delta{N,A} default 0; 	# electric network
param deltaT{A,N} default 0;	# transpose matrix



# VARIABLES --------------------------------------------------
# Firs-level decision variables of firm f ....................
var alfa{P};       # bid for the unit at node in P     

# Primal variables in 2nd-level SPE/OPF..................
var QS{P};          # quantity of power generated by the unit   
var QD{D};          # quantity of power demanded 
var T{A};           # MW transmitted from i to j

# Dual variables in 2nd-level SPE/OPF ...................
var lambda{N};      # marginal cost at node i
var miu{P};         # marginal value of generation capacity for the unit at node i
var teta{A};        # marginal value of transmission capacity
var gamma{L};       # shadow price for Kirchhoff voltage law
    

# FUNCTION TO MAXIMIZE ----------------------------------------
maximize profit: 
sum{n in D} (c[n]*QD[n]-d[n]*QD[n]^2) - sum{k in Sf}(a[k]*QS[k]+(b[k]/2)*(QS[k]^2)) - 
sum{(i,j) in A} (teta[i,j]*Ts[i,j]) - 
sum{l in P} (if l in Sf then 0 else (miu[l]*QS_s[l]+a[l]*QS[l]+b[l]*QS[l]^2)); 


# CONSTRAINTS ------------------------------------------------
subject to 

r1 {n in P}:    alfa_i[n] <= alfa[n] <= alfa_s[n];

r2{n in P}:  0<= QS_s[n]-QS[n] complements miu[n] >=0;

r3{n in P}:  0<= QS[n] complements alfa[n] - lambda[n]+miu[n]+b[n]*QS[n] >=0;

r4{n in D}:  0<= QD[n] complements lambda[n] - c[n] + d[n]*QD[n] >= 0;

r5{(i,j) in A}:  0<= teta[i,j] complements Ts[i,j] - T[i,j] >= 0;

r6{(i,j) in A}: 0<= T[i,j] complements sum{n in N}(deltaT[i,j,n]*lambda[n])+teta[i,j]+sum {k in L} (RRT[i,j,k]*gamma[k]) >= 0; 

r7 {n in N}:
  (if n in D then QD[n] else 0)-(if n in P then QS[n] else 0)+sum {(i,j) in A} (delta[n,i,j]*T[i,j])=0;

r8 {k in L}:
  sum{(i,j) in A} (RR[k,i,j]*T[i,j])=0;


data;
#-----------------------------------------------------------------------------------------------------------------------
set N  := 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30;
set A :=   (1,2) (1,3)
        (2,4) (2,5) (2,6)
        (3,4)
        (6,4) (4,12)
        (5,7)
        (7,6) (8,6) (9,6) (10,6) (6,28)
        (28,8)
        (9,10) 
        (10,17) (20,10) (21,10) (22,10)
        (11,9)
        (12,13) (12,14) (12,15) (12,16)
        (15,14)
        (15,18) (15,23)
        (17,16)
        (18,19)
        (19,20)
        (22,21)
        (24,22)
        (24,23)
        (24,25)
        (25,26) (27,25)
        (29,27) (27,30)
        (27,28)
        (29,30);
        
set Sf := 8 11 13;
set P  := 1 2 5 8 11 13;
set D  := 2 3 4 5 7 8 10 12 14 15 16 17 18 19 20 21 23 24 26 29 30;
set L := 1 2 3 4 5 6 7 8 9 10 11 12;


param a :=				
1	20
2	17.5
5	10
8	32.5
11	30
13	30;


param b :=
1	0.0375
2	0.1750
5	0.6250
8	0.0834
11	0.2500
13	0.2500;


param c := 
2	40
3	40	
4	40
5	40
7	40
8	40
10	40
12	40
14	40
15	40
16	40
17	40
18	40
19	40
20	40
21	40
23	40
24	40
26	40
29	40
30	40;


param d := 
2	0.461	
3	4.167
4	1.316
5	0.106
7	0.439
8	0.333
10	1.724
12	0.893
14	1.613
15	1.220
16	2.857
17	1.111
18	3.125
19	1.053
20	4.545
21	0.571
23	3.125
24	1.149
26	2.857
29	4.167
30	0.943;


param alfa_s :=
1   20
2   17.5
5   10
8   40
11  40
13  40;


param alfa_i :=
1   20
2   17.5
5   10
8   0
11  0
13  0;


param QS_s :=
1   200
2   80
5   50
8   35
11  30
13  40;


param:   Ts:=
1   2    78
1   3    78
2   4    39
2   5    78
2   6    39
3   4    78
4   12   39
5   7    42
6   4    54
6   28  19.2
7   6    78
8   6   19.2
9   6    39
9   10   39
10  6   19.2
10  17  19.2
11  9    39
12  13   39
12  14  19.2
12  15  19.2
12  16  19.2
15  14   9.6
15  18   9.6
15  23   9.6
17  16   9.6
18  19   9.6
19  20  19.2
20  10  19.2
21  10  19.2
22  10  19.2
22  21  19.2
24  22   9.6
24  23   9.6
24  25   9.6
25  26   9.6
27  25   9.6
27  28   39
29  27   39
27  30   39
28  8   19.2
29  30   39;


param: 		RR :=
1	2	6	0.1763	
1	6	4	0.0414
1	2	4	-0.1737
2	6	28	0.0599
2	28	8	0.2000
2	8	6	0.0420
3	9	6	-0.2080
3	9	10	0.1100
3	10	6	0.5560
4	22	10	-0.1499
4	22	21	0.0236
4	21	10	0.0749
5	12	14	0.2559
5	15	14	-0.1997
5	12	15	-0.1304
6	27	30	0.6027
6	29	30	-0.4533
6	29	27	0.4153
7	1	2	0.0575
7	2	4	0.1737
7	3	4	-0.0379
7	1	3	-0.1852
8	2	5	0.1983
8	5	7	0.1160
8	7	6	0.0820
8	2	6	-0.1763
9	6	4	-0.0414
9	10      6	-0.5560
9	10	17	0.0845
9	17	16	0.1932
9	12	16	-0.1987
9	4	12	-0.2560
10	6	28	0.0599
10	27	28	-0.3960
10	27	25	0.2087
10	24	25	-0.3292
10	24	22	0.1790
10	22	10	0.1499
10	10	6	0.5560
11	20	10	-0.2090
11	19	20	-0.0680
11	18	19	-0.1292
11	15	18	-0.2185
11	12	15	-0.1304
11	12	16	0.1987
11	17	16	-0.1932
11	10	17	-0.0845
12	22	10	-0.1499
12	24	22	-0.1790
12	24	23	0.2700
12	15	23	-0.2020
12	15	18	0.2185
12	18	19	0.1292
12	19	20	0.0680
12	20	10	0.2090;


param: 		RRT :=
2	6	1	0.1763	
6	4	1	0.0414
2	4	1	-0.1737
6	28	2	0.0599
28	8	2	0.2000
8	6	2	0.0420
9	6	3	-0.2080
9	10	3	0.1100
10	6	3	0.5560
22	10	4	-0.1499
22	21	4	0.0236
21	10	4	0.0749
12	14	5	0.2559
15	14	5	-0.1997
12	15	5	-0.1304
27	30	6	0.6027
29	30	6	-0.4533
29	27	6	0.4153
1	2	7	0.0575
2	4	7	0.1737
3	4	7	-0.0379
1	3	7	-0.1852
2	5	8	0.1983
5	7	8	0.1160
7	6	8	0.0820
2	6	8	-0.1763
6	4	9	-0.0414
10      6	9	-0.5560
10	17	9	0.0845
17	16	9	0.1932
12	16	9	-0.1987
4	12	9	-0.2560
6	28	10	0.0599
27	28	10	-0.3960
27	25	10	0.2087
24	25	10	-0.3292
24	22	10	0.1790
22	10	10	0.1499
10	6	10	0.5560
20	10	11	-0.2090
19	20	11	-0.0680
18	19	11	-0.1292
15	18	11	-0.2185
12	15	11	-0.1304
12	16	11	0.1987
17	16	11	-0.1932
10	17	11	-0.0845
22	10	12	-0.1499
24	22	12	-0.1790
24	23	12	0.2700
15	23	12	-0.2020
15	18	12	0.2185
18	19	12	0.1292
19	20	12	0.0680
20	10	12	0.2090;

param: 		delta :=
1     1     2      1
1     1     3      1
2     1     2     -1
2     2     4      1
2     2     5      1
2     2     6      1
3     1     3     -1
3     3     4      1
4     2     4     -1
4     3     4     -1
4     6     4     -1
4     4     12     1
5     2     5     -1
5     5     7      1
6     2     6     -1
6     7     6     -1
6     8     6     -1
6     9     6     -1
6     10    6     -1
6     6     4      1
6     6     28     1
7     5     7     -1
7     7     6      1
8     8     6      1
8     28    8     -1
9     9     6      1
9     9     10     1
9     11    9     -1
10    9     10    -1
10    20    10    -1
10    21    10    -1 
10    22    10    -1
10    10    6      1
10    10    17     1
11    11    9      1
12    4     12    -1
12    12    13     1
12    12    14     1
12    12    15     1
12    12    16     1
13    12    13    -1
14    12    14    -1
14    15    14    -1
15    12    15    -1
15    15    14     1
15    15    18     1
15    15    23     1
16    12    16    -1
16    17    16    -1
17    17    16     1
17    10    17    -1
18    15    18    -1
18    18    19     1
19    18    19    -1
19    19    20     1
20    19    20    -1
20    20    10     1
21    21    10     1
21    22    21    -1
22    22    10     1
22    22    21     1
22    24    22    -1
23    15    23    -1
23    24    23    -1
24    24    22     1
24    24    23     1
24    24    25     1
25    24    25    -1
25    27    25    -1
25    25    26     1
26    25    26    -1
27    29    27    -1
27    27    25     1
27    27    28     1
27    27    30     1
28    6     28    -1
28    27    28    -1
28    28     8     1
29    29    27     1
29    29    30     1
30    27    30    -1
30    29    30    -1;


param: 		deltaT :=
1     2     1      1
1     3     1      1
1     2     2     -1
2     4     2      1
2     5     2      1
2     6     2      1
1     3     3     -1
3     4     3      1
2     4     4     -1
3     4     4     -1
6     4     4	  -1
4     12    4      1
2     5     5     -1
5     7     5      1
2     6     6     -1
7     6     6     -1
8     6     6     -1
9     6     6     -1
10    6     6     -1
6     4     6      1
6     28    6      1
5     7     7     -1
7     6     7      1
8     6     8      1
28    8     8     -1
9     6     9      1
9     10    9      1
11    9     9     -1
9     10    10    -1
20    10    10    -1
21    10    10    -1 
22    10    10    -1
10    6     10     1
10    17    10     1
11    9     11     1
4     12    12    -1
12    13    12     1
12    14    12     1
12    15    12     1
12    16    12     1
12    13    13    -1
12    14    14    -1
15    14    14    -1
12    15    15    -1
15    14    15     1
15    18    15     1
15    23    15     1
12    16    16    -1
17    16    16    -1
17    16    17     1
10    17    17    -1
15    18    18    -1
18    19    18     1
18    19    19    -1
19    20    19     1
19    20    20    -1
20    10    20     1
21    10    21     1
22    21    21    -1
22    10    22     1
22    21    22     1
24    22    22    -1
15    23    23    -1
24    23    23    -1
24    22    24     1
24    23    24     1
24    25    24     1
24    25    25    -1
27    25    25    -1
25    26    25     1
25    26    26    -1
29    27    27    -1
27    25    27     1
27    28    27     1
27    30    27     1
6     28    28    -1
27    28    28    -1
28     8    28     1
29    27    29     1
29    30    29     1
27    30    30    -1
29    30    30    -1;



#solve;
#
#display profit;
#display alfa;
#display QD;
#display QS;
#display T;








