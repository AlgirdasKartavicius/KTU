clc
A=[ 2 -1  0  0  0  0 -1;
   -1  2 -1  0  0  0  0;
    0 -1  2 -1  0  0  0;
    0  0 -1  2 -1  0  0;
    0  0  0 -1  2 -1  0;
    0  0  0  0 -1  2 -1;
   -1  0  0  0  0 -1  2;]
S=sparse(A)
B=full(S)

i=[1 2 7 1 2 3 2 3 4 3 4 5 4 5 6 5 6 7 1 6 7];
j=[1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 7 7 7];
s=[2 -1 -1 -1 2 -1 -1 2 -1 -1 2 -1 -1 2 -1 -1 2 -1 -1 -1 2 ];
S1=sparse(i,j,s)
B1=full(S1)